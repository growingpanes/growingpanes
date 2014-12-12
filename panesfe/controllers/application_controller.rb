require 'helpers/helpers'
module Panesfe
  module Controllers
    class ApplicationController < Sinatra::Application
      helpers CurrentUserHelper, I18nHelper, RenderHelper

      configure do
        set :raise_errors, true # throw exceptions up the rack stack
        set :show_exceptions, false # disable html error pages
        set :dump_errors, false # disable stack traces for handled errors

        set :views, 'views'
        set :root, App.root

        set :erb, layout_options: {views: 'views/layouts'},
                  layout: 'application.html'.to_sym
        Tilt.register 'html.erb'.intern, Tilt[:erb]

        set :logging, Logger::DEBUG
        logger = Logger.new $stdout
        logger.level = Logger::DEBUG
        logger.datetime_format = '%a %d-%m-%Y %H%M '
        set :logger, logger
        $stdout.sync = true
        OmniAuth.config.logger = logger
        DataMapper.logger = logger


        helpers do
          def logger
            settings.logger
          end
        end

      end

      ROUTE_WHITELIST = Hash.new
      %w{
        /auth
        /auth/google_oauth2/callback
        /logout
        /
      }.each {|r| ROUTE_WHITELIST[r] = true}
      before do
        pass if ROUTE_WHITELIST[request.path_info]
        require_user
      end

      def logged_in_home
        '/presentations'
      end

    end
  end
end
