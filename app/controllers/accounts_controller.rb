class AccountsController < ApplicationController
  skip_before_action :require_login

  def create
    @usr = Person.new person_params

    if @usr.save
      AccountMailer.signup(@usr).deliver_later
      OMNILOGGER.account ltag(@usr, 'CREATE account (registration)')
      render 'verify'
    else
      render 'new'
    end
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
    params.require(:person).permit(:display_name, :email, :password, :password_confirmation)
  end
end