require 'rubygems'
require 'bundler/setup'

require 'sinatra'
require 'pp'

$pings = []

get '/' do
  erb :index
end

post '/ping' do
  $pings << request.body.string
end

__END__

@@ index

<html>
  <body>
    <% $pings.each do |ping| %>
      <pre><%= $ping %></pre>
      <hr>
    <% end %>
  </body>
</html>

