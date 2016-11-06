class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  layout 'application' #, :except => [:blogfeed]
  before_action :retrieve_user
  before_action :require_login

  # before_filter :title, :check_ip

  #def title
  #end

  # TODO: what is this? is this supposed to be a test?
  def check_ip
    render :text => "Sorry, something went wrong." if ["74.96.142.81"].include? current_ip_address
  end

  def current_ip_address
    request.env['HTTP_X_REAL_IP'] || request.env['REMOTE_ADDR']
  end

  def verify
    unless Person.find(session[:person_id]).email_verified
      session[:original_url] = request.request_uri
      flash[:notice]         = "You must verify your email address before you can post."
      redirect_to :controller => "main", :action => "index"
    end
  end

  def authorize_as_commenter
    unless Person.find(session[:person_id]).can_comment
      flash[:notice] = "Sorry, your account doesn't seem to have commenting and flagging enabled."
      redirect_to :controller => "main", :action => "index"
    end
  end

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
