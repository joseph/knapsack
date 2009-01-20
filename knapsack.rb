require 'rubygems'
require 'open-uri'
require 'base64'
require 'vendor/hpricot-0.6/lib/hpricot.rb'
require 'vendor/sinatra/lib/sinatra.rb' unless defined?(Sinatra)

require 'models/resource'
require 'models/page'
require 'models/stylesheet'

get '/' do
  if params[:url]
    url = params[:url]
    url = "http://#{url}" unless url.match("://")
    @data = Resource.fetch_and_convert(url)
    erb :result
  else
    erb :index
  end
end

error do
  request.env['sinatra.error'].to_s
end

use_in_file_templates!

__END__

@@ index
<html>
  <head>
    <title>Knapsack</title>
  </head>
  <body>
    <h1>Knapsack</h1>
    <p>
      Enter the URL you want to store offline:
      <form action="/" method="GET">
        <input type="text" name="url" />
        <input type="submit" value="Pack it" />
      </form>
    </p>
  </body>
</html>


@@ result
<html>
  <head>
    <title>Loading...</title>
  </head>
  <body>
    <script>location.href = "<%= @data %>";</script>
  </body>
</html>
