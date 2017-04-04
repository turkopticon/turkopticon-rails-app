class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  layout 'application'
  before_action :retrieve_user
  before_action :require_login

  private

  def retrieve_user
    @user ||= session[:person_id] ? Person.find(session[:person_id]) : nil

    @notifications         = {}
    @notifications[:flags] = Flag.status(:open).size if @user && @user.moderator?
  end

  def require_login
    unless @user
      session[:original_uri] = request.fullpath
      flash[:notice]         = 'Please login to continue'
      redirect_to new_session_path
    end
  end

  def require_access_level(access_level)
    render 'accounts/unauthorized' unless @user.send (access_level.to_s + '?').to_sym
  end

  def ltag(user = nil, msg)
    '%15s (u#%6d) -- %s' % [request.ip, (user || @user).id, msg]
  end

end
