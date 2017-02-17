class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  layout 'application'
  before_action :retrieve_user
  before_action :require_login

  OMNILOGGER ||= Omnilogger.new :account, :flag, :review, :moderator, :admin

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

  def require_access_level(access_level)
    render 'accounts/unauthorized' unless @user.send (access_level.to_s + '?').to_sym
  end

  def ltag(user = nil, msg)
    # usr = user.display_name.nil? || user.display_name.empty? ? user.email.split('@')[0] : user.display_name
    # '%15s (%s#%d) -- %s' % [request.ip, usr, user.id, msg]
    '%15s (%s) -- %s' % [request.ip, (user || @user).email, msg]
  end

end
