class AccountMailer < ApplicationMailer
  default host: 'turkopticon.info'

  def signup(user)
    @user     = user
    @greeting = 'Welcome' << (user.display_name.blank? ? '!' : ", #{user.display_name}!")

    mail to: user.email, subject: 'New Account Registration'
  end

end
