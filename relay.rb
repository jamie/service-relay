require 'rubygems'
require 'bundler/setup'

require 'sinatra'
require 'hipchat'
require 'savon'
require 'httparty'
require 'time'
require 'json'
require 'cgi'

require './lib/pivotal_ping'

if File.exist?('./env')
  File.read('./env').each_line do |line|
    k,v = line.chomp.split('=', 2)
    ENV[k] = v if k
  end
end

get '/' do
  erb :index
end

# TODO: change to '/pivotal/to/hipchat'
post '/ping' do
  ping = PivotalPing.new(request.body.read)
  unless ping.description =~ /^[^"].*edited "/
    hipchat = HipChat::Client.new(ENV['HIPCHAT_TOKEN'])
    room = ENV['HIPCHAT_ROOM'].gsub('_', ' ')
    hipchat[room].send('Pivotal Tracker', ping.description)
  end
  ''
end

class Salesforce
  def initialize
    @soap_client = Savon::Client.new do
      wsdl.document = File.expand_path("../lib/salesforce_partner.wsdl", __FILE__)
    end
  end

  def login!
    @soap_client.request :login do
      soap.body = {
        :username => ENV['SALESFORCE_LOGIN'],
        :password => ENV['SALESFORCE_PASSWORD'] + ENV['SALESFORCE_TOKEN']
      }
    end
  end

  def get_cases
    url = "https://na4-api.salesforce.com/services/data/v24.0/query/"
    query = "SELECT id, subject, description, createddate, " +
      "suppliedname, status from Case where Status LIKE 'Escalated%'"
    response = HTTParty.get(
      url,
      :query => { :q => query },
      :headers => {
        'Authorization' => "OAuth #{session_id}",
        'X-PrettyPrint' => '1'
      }
    )
    puts response.code
    JSON.parse(response.body)["records"]
  end

  def session_id
    ''
  end

end


get '/salesforce/to/pivotal' do
  @cases = Salesforce.new.get_cases
  content_type 'application/json'
  erb :pt_import_xml
end

#require 'pp'
#force = Salesforce.new
#force.login!
#force.logout!
#exit(1)

__END__

@@ index

<html><body>No content</body></html>

@@ pt_import_xml
<?xml version="1.0" encoding="UTF-8"?>
<external_stories type="array">
<% @cases.each do |c| %>
  <external_story>
    <external_id><%= c['Id'] %></external_id>
    <name><%= c['Subject'] %></name>
    <description><%= CGI.escape c['Description'] %></description>
    <requested_by><%= c['SuppliedName'] %></requested_by>
    <created_at type="datetime"><%= Time.parse(c['CreatedDate']).strftime('%Y/%m/%d %H:%M:%S UTC') %></created_at>
    <story_type><%= c['Status'].split('--').last.downcase %></story_type>
    <estimate type="integer"></estimate>
  </external_story>
<% end %>
</external_stories>
