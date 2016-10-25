class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  layout "generic", :except => [:blogfeed]

  before_filter :title, :check_ip

  #def title
  #end

  # TODO: what is this? is this supposed to be a test?
  def check_ip
    render :text => "Sorry, something went wrong." if ["74.96.142.81"].include? current_ip_address
  end

  def current_ip_address
    request.env['HTTP_X_REAL_IP'] || request.env['REMOTE_ADDR']
  end

  def authorize
    unless !session[:person_id].nil? and Person.find(session[:person_id]) and !Person.find(session[:person_id]).is_closed
      session[:original_uri] = request.request_uri
      flash[:notice]         = "Please log in."
      redirect_to :controller => "reg", :action => "login"
    end
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

end
