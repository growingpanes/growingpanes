# Defines our constants
RACK_ENV = ENV['RACK_ENV'] ||= 'development'  unless defined?(RACK_ENV)

require 'bundler/setup'
Bundler.require(:default, RACK_ENV)
Dotenv.load
$: << File.expand_path('../lib', __FILE__)
I18n.enforce_available_locales = true
I18n.config.available_locales = ['en']
I18n.config.default_locale = :en
I18n.load_path += Dir[File.join(File.dirname(__FILE__), 'locales', '*.yml').to_s]

module Panesfe
  class App < Sinatra::Application
    configure do
      disable :method_override

      enable :static
      set :public_folder, File.join(settings.root, 'public')

      disabled_protection = [:ip_spoofing]
      set :protection, :except => disabled_protection

      raise "No session secret found." unless ENV['SESSION_SECRET']
      set :sessions,
            :key          => 'panesfe.session',
            :path         => '/',
            :httponly     => true,
            :secure       => production?,
            :expire_after => 31557600, # 1 year
            :secret       => ENV['SESSION_SECRET']
    end

    use OmniAuth::Builder do
      provider :google_oauth2, ENV['GOOGLE_OAUTH2_ID'], ENV['GOOGLE_OAUTH2_SECRET']
    end

  end
end

require 'db/init'
require 'controllers/controllers'
require 'models/models'
require 'db/finalize'
