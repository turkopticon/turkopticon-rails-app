class SessionsController < ApplicationController
  skip_before_action :require_login

  def create
    # email = params[:email].split('@')
    # if email[0] == 'admin'
    #   session[:person_id] = email[1]
    #   return redirect_to root_path
    # end
    user = Person.find_by(email: params[:email])
    # msg = 'Please verify or update your email address to continue using Turkopticon'
    if user && !user.is_closed? && user.authenticate(params[:password])
      # return redirect_to '/reg/change_email', notice: msg unless user.verified?

      time                = Time.now.strftime('%H:%M %a %b %d %Y')
      session[:person_id] = user.id
      logger.info "[#{time}] #{user.email} logged in from #{request.remote_ip}"

      uri                    = session[:original_uri]
      session[:original_uri] = nil
      redirect_to uri || root_path
    else
      flash[:notice] = 'Sorry, invalid username/password combination'
      render 'sessions/new'
    end
  end

  def destroy
    @user               = nil
    session[:person_id] = nil
    flash[:notice]      = 'Logged out'
    redirect_to root_path
  end
end