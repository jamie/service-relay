require 'rubygems'
require 'bundler/setup'

require 'sinatra'
require 'pp'

$pings = []

get '/' do
  erb :index
end

post '/ping' do
  $pings << request.body
end

__END__

@@ index

<html>
  <body>
    <pre><%= $pings.pretty_inspect %></pre>
  </body>
</html>

