require 'rubygems'
require 'bundler/setup'

require 'sinatra'
require './lib/pivotal_ping'

$pings = []

get '/' do
  erb :index
end

post '/ping' do
  $pings << PivotalPing.new(request.body.read)
end

__END__

@@ index

<html>
  <body>
    <% $pings.each do |ping| %>
    <pre><%= "%10s %10s %s %s" % [ping.id, ping.event_type, ping.description, ping.story_ids.join(',')] %></pre>
    <% end %>
  </body>
</html>

