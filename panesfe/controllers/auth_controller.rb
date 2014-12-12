module Panesfe
  module Controllers
    class AuthController < ApplicationController
      get "/auth" do
        redirect to('/auth/google_oauth2')
      end

      get "/auth/:provider/callback" do
        @user = User.find_or_create_with_omniauth(auth_hash)
        self.current_user = @user
        redirect to(logged_in_home)
      end

      get "/logout" do
        clear_current_user
        redirect to('/')
      end


      protected

      def auth_hash
        request.env['omniauth.auth']
      end
    end
  end

  class App
    use Controllers::AuthController
  end
end
