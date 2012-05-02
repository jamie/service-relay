require 'rubygems'
require 'bundler/setup'

require 'sinatra'
require 'hipchat'
require 'httparty'
require 'time'

require './lib/pivotal_ping'
require './lib/salesforce'

if File.exist?('./env')
  File.read('./env').each_line do |line|
    k,v = line.chomp.split('=', 2)
    ENV[k] = v if k
  end
end

use Rack::Auth::Basic, "Restricted Area" do |user, pass|
  [user, pass] == ['pivotal', 'password']
end


helpers do
  def h(text)
    text.gsub('<', '%3C').gsub('>','%3E')
  end
end

get '/' do
  erb :index
end

# TODO: change to '/pivotal/webhook'
post '/ping' do
  ping = PivotalPing.new(request.body.read)
  # HipChatNotifier.process(ping)
  # SalesforceUpdater.process(ping)
  unless ping.description =~ /^[^"].*edited "/
    hipchat = HipChat::Client.new(ENV['HIPCHAT_TOKEN'])
    room = ENV['HIPCHAT_ROOM'].gsub('_', ' ')
    hipchat[room].send('Pivotal Tracker', ping.description)
  end
  ''
end

get '/salesforce/to/pivotal' do
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
    <story_type><%= c['Status'].split('--').last.downcase %></story_type>
    <estimate type="integer"></estimate>
  </external_story>
<% end %>
</external_stories>

