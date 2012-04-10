require 'rubygems'
require 'bundler/setup'

require 'sinatra'
require 'pp'

$pings = []

get '/' do
  erb :index
end

post '/ping' do
  $pings << params
end

__END__

@@ index

<html>
  <body>
    <% $pings.each do |ping| %>
      <pre><%= $ping.pretty_inspect %></pre>
      <hr>
    <% end %>
  </body>
</html>

