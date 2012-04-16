require 'rubygems'
require 'bundler/setup'

require 'sinatra'
require 'hipchat'
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

post '/ping' do
  ping = PivotalPing.new(request.body.read)
  unless ping.description =~ /^[^"].*edited "/
    hipchat = HipChat::Client.new(ENV['HIPCHAT_TOKEN'])
    room = ENV['HIPCHAT_ROOM'].gsub('_', ' ')
    hipchat[room].send('Pivotal Tracker', ping.description)
  end
  ''
end

__END__

@@ index

<html><body>No content</body></html>

