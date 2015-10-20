class NotificationMailer < ActionMailer::Base

  def notification(n)
    @subject = '[turkopticon] ' + n.title
    @body["body"] = n.body
    @recipients = n.person.email
    @from = 'turkopticon@ucsd.edu'
    @bcc = 'turkopticon.maint@gmail.com'
    @sent_on = Time.now
    @headers = {}
  end

  def digest
    @subject = '[turkopticon-discuss] ' + 'Notifications digest'

    @recipients = n.person.email
    @from = 'turkopticon@ucsd.edu'
    @bcc = 'turkopticon.maint@gmail.com'
    @sent_on = Time.now
    @headers = {}
  end

end