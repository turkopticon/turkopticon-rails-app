class PasswordResetsController < ApplicationController
  skip_before_action :require_login

  def show
    @usr = Person.where('password_reset_expiration > ?', Time.now).find_by! password_reset_token: params[:token]
  end

  def create
    user = Person.find_by email: params[:email]
    if user
      user.send_password_reset request.ip
      render html: '<p>An email has been sent with password reset instructions</p>'.html_safe, layout: true
    else
      flash.now[:error] = 'User does not exist'
      render 'new'
    end
  end

  def update
    @usr   = Person.find_by password_reset_token: params[:token]
    fields = password_params.merge password_reset_token: nil, password_reset_expiration: nil
    @usr.assign_attributes fields
    if @usr.save context: params[:context].to_sym
      flash[:success] = 'Password has been updated'
      redirect_to new_session_path
    else
      flash.now[:error] = 'There was an error updating your password'
      render 'show'
    end
  end

  private

  def password_params
    params.require(:person).permit(:password, :password_confirmation)
  end
end