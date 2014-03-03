# Load path and gems/bundler
$LOAD_PATH << File.expand_path(File.dirname(__FILE__))

require "bundler"
if ENV['RACK_ENV'] == 'development'
  Bundler.require(:default, :development)
else
  Bundler.require(:default)
end

require 'sass/plugin/rack'
use Sass::Plugin::Rack

# Local config
require "find"

# Load app
require "etsy_map_app"
run EtsyMapApp