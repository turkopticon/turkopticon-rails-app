class AccountsController < ApplicationController
  skip_before_action :require_login

  def create
    user = Person.new person_params

    if user.save
      AccountMailer.signup(user).deliver_later
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