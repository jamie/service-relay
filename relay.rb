require 'rubygems'
require 'bundler/setup'

require 'sinatra'

$pings = []

get '/' do
  "Sinatra up and running with #{$pings.size} pings"
end

post '/ping' do
  $pings << params
end

