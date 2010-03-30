# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  rescue_from CanCan::AccessDenied do |exception|
    flash[:error] = exception.message
    redirect_back_or_default(home_url)
  end
  
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details

  # Scrub sensitive parameters from your log
  # filter_parameter_logging :password, :password_confirmation
  helper_method :current_user_session, :current_user
  
  before_filter :must_be_logged_in
  
  protected
  
  def current_user
    return @current_user if defined?(@current_user)
    @current_user = current_user_session && current_user_session.user
  end
  
  def logged_in?
    !!current_user
  end
  
  def load_user_using_perishable_token
    @user = User.find_using_perishable_token(params[:id])
    unless @user
      flash[:notice] = "We're sorry; we've had trouble locating your account. Try copying and pasting the URL from your email, or request a new password link."
      redirect_to home_path
    end
  end
  
  private
  
  def current_user_session
    return @current_user_session if defined?(@current_user_session)
    @current_user_session = UserSession.find
  end
  
  def must_be_logged_in
    unless current_user
      store_location
      flash[:notice] = "You must be logged in to view this page"
      redirect_to new_user_session_url
      return false
    end
  end
  
  def must_be_logged_out
    if current_user
      
      store_location
      flash[:notice] = "You're already logged in; you need to be logged out to view this page"
      redirect_to '/'
      return false
    else
      logger.info "current_user: #{current_user}"
    end
  end
  
  def store_location
    session[:return_to] = request.request_uri
  end
  
  def redirect_back_or_default(default)
    redirect_to(session[:return_to] || default)
    session[:return_to] = nil
  end
  
end
