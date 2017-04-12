class AccountsController < ApplicationController
  skip_before_action :require_login, except: :settings

  def create
    @usr = Person.new person_params

    if @usr.save
      AccountMailer.signup(@usr).deliver_later
      Omnilogger.account ltag(@usr, "CREATE account WITH #{@usr.email}")
      render 'verify'
    else
      render 'new'
    end
  end

  def update
    old_email  = @user.email
    same_email = @user.email == params[:person][:email].downcase
    @user.assign_attributes person_params
    if @user.save context: params[:context].to_sym
      Omnilogger.account ltag(@user, "UPDATE email TO #{@user.email} FROM #{old_email}") unless same_email
      flash[:success] = 'Settings updated'
    else
      flash[:error] = 'Changes were unable to be saved'
    end
    redirect_back fallback_location: account_settings_path
  end

  def activate
    user = Person.find_by(confirmation_token: params[:token])

    if user
      user.activate!
      session[:person_id] = user.id
      flash[:success]     = 'Your email address has been verified.'
    else
      flash[:error] = 'Sorry, user not found.'
    end

    redirect_to root_path
  end

  private

  def person_params
    params.require(:person).permit(:display_name, :email, :time_unit, :password, :password_confirmation)
  end
end