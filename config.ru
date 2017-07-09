require 'rubygems'
require 'bundler/setup'

if ENV['RACK_ENV'].to_s.eql?('development')
  Bundler.require(:default, :development)
elsif ENV['RACK_ENV'].to_s.eql?('testing')
  Bundler.require(:default, :testing)
elsif ENV['RACK_ENV'].to_s.eql?('production')
  Bundler.require(:default)
end

require './app'

# https://github.com/middleman/middleman/issues/2087
Haml::TempleEngine.disable_option_validator!

run Sinatra::Application
