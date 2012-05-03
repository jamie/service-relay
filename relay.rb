require 'rubygems'
require 'bundler/setup'

require 'sinatra'
require 'hipchat'
require 'httparty'
require 'time'

if File.exist?('./env')
  File.read('./env').each_line do |line|
    k,v = line.chomp.split('=', 2)
    ENV[k] = v if k
  end
end

require './lib/hipchat_notifier'
require './lib/pivotal_ping'
require './lib/salesforce'

helpers do
  def h(text)
    text.gsub('<', '%3C').gsub('>','%3E')
  end

  def story_type(k)
    { 'Escalated--Defect'  => 'bug',
      'Escalated--Feature' => 'feature',
      'Escalated--Task'    => 'chore'
    }[k]
  end

  def protected!
    unless authorized?
      response['WWW-Authenticate'] = %(Basic realm="Restricted Area")
      throw(:halt, [401, "Not authorized\n"])
    end
  end

  def authorized?
    @auth ||=  Rack::Auth::Basic::Request.new(request.env)
    @auth.provided? && @auth.basic? && @auth.credentials && @auth.credentials == ENV['BASIC_AUTH'].split(':')
  end

end

get '/' do
  erb :index
end

post '/pivotal/webhook' do
  ping = PivotalPing.new(request.body.read)
  HipchatNotifier.new.process(ping)
  Salesforce.new.process_update(ping)
  'OK'
end

get '/salesforce/to/pivotal' do
  protected!
  @cases = Salesforce.new.get_cases
  content_type 'application/json'
  erb :pt_import_xml
end

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
    <description><%= h c['Description'] %></description>
    <requested_by><%= c['SuppliedName'] %></requested_by>
    <created_at type="datetime"><%= Time.parse(c['CreatedDate']).strftime('%Y/%m/%d %H:%M:%S UTC') %></created_at>
    <story_type><%= story_type(c['Status']) %></story_type>
    <estimate type="integer">-1</estimate>
  </external_story>
<% end %>
</external_stories>

