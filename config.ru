require "rack"

# require "rack-livereload"
# use Rack::LiveReload, min_delay: 500

run Rack::Directory.new("www")
