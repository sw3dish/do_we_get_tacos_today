require 'rubygems'
require 'bundler/setup'

if ENV['RACK_ENV'].to_s.eql?('development')
  Bundler.require(:default, :development)
elsif ENV['RACK_ENV'].to_s.eql?('testing')
  Bundler.require(:default, :testing)
else
  Bundler.require(:default)
end

require 'sass/plugin/rack'
require './app'

if ENV['RACK_ENV'].to_s.eql?('development')
  Sass::Plugin.options[:style] = :expanded
elsif ENV['RACK_ENV'].to_s.eql?('testing')
  Sass::Plugin.options[:style] = :expanded
else
  Sass::Plugin.options[:style] = :compressed
end

# https://github.com/middleman/middleman/issues/2087
Haml::TempleEngine.disable_option_validator!

Dotenv.load

use Sass::Plugin::Rack
run Sinatra::Application
