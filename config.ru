require "rack"

# require "rack-livereload"
# use Rack::LiveReload, min_delay: 500

use Rack::Static, urls: {"/" => "index.html"}, root: "www"

run Rack::Directory.new("www")
