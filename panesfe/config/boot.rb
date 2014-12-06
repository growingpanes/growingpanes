# Defines our constants
RACK_ENV = ENV['RACK_ENV'] ||= 'development'  unless defined?(RACK_ENV)

require 'bundler/setup'
Bundler.require(:default, RACK_ENV)
Dotenv.load

DataMapper.finalize

$: << File.expand_path('../../lib', __FILE__)
require_relative 'everything'
