class AuthController < ApplicationController
  skip_before_filter :require_user, only: [:index, :callback, :logout]
  def callback
    raise "Invalid strategy #{params[:provider].inspect}" unless params[:provider]=='google_oauth2'
    @user = User.find_or_create_with_omniauth(auth_hash)
    self.current_user = @user
    redirect_to(logged_in_home_path)
  end

  def logout
    clear_current_user
    redirect_to home_path
  end

  def index
    redirect_to('/auth/google_oauth2')
  end

  protected

  def auth_hash
    request.env['omniauth.auth']
  end
end
