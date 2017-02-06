class SessionsController < ApplicationController
  skip_before_action :require_login

  def create
    user = Person.find_by(email: params[:email])
    if user && !user.is_closed? && user.authenticate(params[:password])
      # return redirect_to '/reg/change_email', notice: msg unless user.verified?

      time                = Time.now.strftime('%H:%M %a %b %d %Y')
      session[:person_id] = user.id
      logger.info "[#{time}] #{user.email} logged in from #{request.remote_ip}"

      uri                    = session[:original_uri]
      session[:original_uri] = nil

      OMNILOGGER.account ltag(user, 'CREATE session (login)')
      redirect_to uri || root_path
    else
      flash[:notice] = 'Sorry, invalid username/password combination'
      render 'sessions/new'
    end
  end

  def destroy
    OMNILOGGER.account ltag('DESTROY session (logout)')
    @user               = nil
    session[:person_id] = nil
    flash[:notice]      = 'Logged out'
    redirect_to root_path
  end
end