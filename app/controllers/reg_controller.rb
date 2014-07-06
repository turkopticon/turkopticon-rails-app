class RegController < ApplicationController

  @@email_log = '/home/ssilberman/src/turkopticon/log/email_changes.txt'

  def change_email
    @person = Person.find(session[:person_id])
    if request.post?
      @new_email = params[:person][:email]
      log_line = '%i) from "%s" to "%s" at %s' % [ @person.id, @person.email, @new_email, Time.now.strftime("%b %d %Y %H:%M") ]
      File.open( @@email_log, 'a' ) { |ff| ff.write(log_line+"\n") }

      @person.email = @new_email
      @person.email_verified = false
      if @person.save
        RegMailer::deliver_confirm( @person, confirmation_hash(@person.email) )
        flash[:notice] = "An email has been sent to #{@person.email}. Please click the link in the email to verify your email address."
        redirect_to :controller => "main", :action => "index"
      end
    end
  end

  def register
    @pagetitle = "register"
    @person = Person.new(params[:person])
    if request.post? and @person.save
      @person.update_attributes(:display_name => @person.public_email)
      RegMailer::deliver_confirm(@person, confirmation_hash(@person.email))
      session[:person_id] = @person.id
      flash[:notice] = "Thanks for signing up. We've sent an email to #{@person.email}. Please click the link in the email to verify your address."
      redirect_to :controller => "main", :action => "index"
    end
  end

  def login
    session[:person_id] = nil

    if request.post? # or cookies[:person_id]
      # if cookies[:person_id]
        # session[:person_id] = cookies[:person_id].to_i
        # person = Person.find(session[:person_id])
        #if person
          #IPLogger.info "[#{Time.now}] #{person.email} logged in with cookie from #{request.remote_ip}"
          #uri = session[:original_uri]
          #session[:original_uri] = nil
          #redirect_to uri || {:controller => "main", :action => "index"}
        #else
          #render :text => "invalid cookie"
        #end
      #else
      # NEED TO INDENT TWO SPACES HERE
      person = Person.authenticate(params[:email], params[:password])
      if person and !person.is_closed
        # Continue normal login process
        session[:person_id] = person.id
        if person.id == 1
          cookies['person_id'] = "1" # {:value => person.id.to_s, :expires => Time.now + 3600 * 24 * 30}
          IPLogger.info "    cookies['person_id']: #{cookies['person_id']}"
        end

        t = Time.now.strftime("%H:%M %a %b %d %Y")
        ip = request.remote_ip
        IPLogger.info "[#{t}] #{person.email} logged in from #{ip}"
        # IPLogger.info "    cookies: #{cookies.inspect}"
        logger.info "[#{t}] #{person.email} logged in from #{ip}"

        # Check if email is verified
        if person.email_verified.nil? or person.email_verified == false
          flash[:notice] = "Please verify your current email address, or update your email address, to continue using Turkopticon."
          RegMailer::deliver_confirm( person, confirmation_hash(person.email) )
          redirect_to :action => "change_email"
        else      
          uri = session[:original_uri]
          session[:original_uri] = nil
          redirect_to (uri || {:controller => "main", :action => "index"})
        end
      else
        flash[:notice] = "Sorry, invalid username/password combination."
      end
      # END NEW INDENT
      #end
    end
  end

  def logout
    session[:person_id] = nil
    #cookies.delete :person_id
    flash[:notice] = "Logged out."
    redirect_to :controller => "main", :action => "index"
  end
  
  def settings
    @person = Person.find(session[:person_id])
  end

  def set_display_name
    @person = Person.find(session[:person_id])
    if @person.display_name and @person.display_name != @person.public_email
      flash[:errors] = {}
      flash[:errors][:display_name] = "You already have a display name."
    elsif Person.find_by_display_name(params[:person][:display_name])
      flash[:errors] = {}
      flash[:errors][:display_name] = "The display name '#{params[:person][:display_name]}' is taken."
    else
      @person.update_attributes(params[:person])
    end
    redirect_to :controller => "reg", :action => "settings"
  end

  def change_password
    @person = Person.find(session[:person_id])
    if request.post?
      if params[:person][:password] != params[:person][:password_confirmation]
        flash[:errors] = {}
        flash[:errors][:password] = "Password and confirmation must match."
        redirect_to :action => "settings"
      else
        @new_password = params[:person][:password]
        @person.password=(@new_password)
        if @person.save
          RegMailer::deliver_password_change(@person, @new_password)
          flash[:notice] = "Your password has been changed. A confirmation email has been sent to #{@person.email}."
          redirect_to :controller => "main", :action => "index"
        end
      end
    end
  end

  def reset_password
    if request.post?
      @person = Person.find_by_email(params[:person][:email])
      if @person.nil?
        flash[:notice] = "Sorry, that email isn't in the database."
      else
        @new_password = @person.object_id.to_s.gsub(/0/, 'j').gsub(/4/, 'x_')
      	@person.password=(@new_password)
        if @person.save
      	  RegMailer::deliver_password_reset(@person, @new_password)
      	  flash[:notice] = "Your password has been reset. An email containing the new password has been sent to to #{@person.email}."
      	  redirect_to :controller => "reg", :action => "login"
      	end
      end
    end
  end

  def send_verification_email
    @person = Person.find(session[:person_id])
    RegMailer::deliver_confirm(@person, confirmation_hash(@person.email))
    flash[:notice] = "An email has been sent to #{@person.email}. Please click the link in the email to verify your email address."
    redirect_to :controller => "main", :action => "index"
  end

  def confirm
    for person in Person.find(:all)
      if confirmation_hash(person.email) == params[:hash] and person.update_attributes(:email_verified => true)
        if session[:person_id].blank?
          session[:person_id] = person.id
        end
        flash[:notice] = "Thank you for confirming your email address."
        redirect_to :controller => "main", :action => "index" and return
      end
    end
  end

  def toggle_my_reviews_order_flag
    Person.find(session[:person_id]).toggle_my_reviews_order_flag
    redirect_to :controller => "main", :action => "my_reviews"
  end

  private
  def confirmation_hash(string)
    Digest::SHA1.hexdigest(string + "sauron_is_watching_you")
  end

end
