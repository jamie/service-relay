require 'rubygems'
require 'bundler/setup'

require 'sinatra'
require 'hipchat'
require 'httparty'
require 'time'
require 'json'
require 'builder'

require './lib/load_dev_env'

require './lib/hipchat_notifier'
require './lib/pivotal_ping'
require './lib/salesforce'
require './lib/salesforce_pivotal_formatter'

helpers do
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
  SalesforcePivotalFormatter.new(@cases).to_xml
end

__END__

@@ index
<html><body>No content</body></html>

