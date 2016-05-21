class ApplicationController < ControllerBase
  def current_user
    @current_user ||= User.where(session_token: session[:session_token])[0]
  end

  def login!(user)
    session[:session_token] = user.reset_session_token!
  end

  def logout!
    current_user.reset_session_token!
    session[:session_token] = nil
  end
end
