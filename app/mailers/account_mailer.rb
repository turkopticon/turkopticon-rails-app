class AccountMailer < ApplicationMailer
  default host: 'turkopticon.info'

  def signup(user)
    @user     = user
    @greeting = 'Welcome' << (user.display_name.blank? ? '!' : ", #{user.display_name}!")

    mail to: user.email, subject: 'New Account Registration'
  end

  def password_reset(user, ip)
    @user  = user
    @token = user.password_reset_token
    @ip    = ip

    mail to: user.email, subject: 'Password Reset Requested'
  end

end
