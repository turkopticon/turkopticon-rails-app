# from http://stackoverflow.com/questions/1901972/sending-emails-with-rails-2-2-2-gmail

ActionMailer::Base.smtp_settings = {
  :enable_starttls_auto => true,
  :address => "smtp.gmail.com",
  :port => 587,
  :domain => "gmail.com",
  :authentication => :plain,
  :user_name => "username@gmail.com",
  :password => "password"
}
