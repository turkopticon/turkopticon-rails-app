class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  layout 'application'
  before_action :retrieve_user
  before_action :require_login

  private

  def retrieve_user
    @user ||= session[:person_id] ? Person.find(session[:person_id]) : nil
  end

  def require_login
    unless @user
      session[:original_uri] = request.fullpath
      flash[:notice]         = 'Please login to continue'
      redirect_to new_session_path
    end
  end

end
