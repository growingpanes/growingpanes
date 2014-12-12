module CurrentUserHelper
  def current_user
    return @current_user if @current_user
    return nil unless session[:auth_email]
    @current_user = User.find_by(email: session[:auth_email])
    return @current_user
  end

  def current_user=(user)
    unless user && user.email
      raise ArgumentError, "Can't log in a user with no email"
    end
    session[:auth_email] = user.email
  end

  def clear_current_user
    session[:auth_email] = nil
  end

  def require_user
    unless current_user
      redirect_to("/auth?origin=#{CGI.escape(request.fullpath)}")
    end
  end
end
