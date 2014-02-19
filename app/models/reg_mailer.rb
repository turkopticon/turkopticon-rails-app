class RegMailer < ActionMailer::Base

  @@send_bcc = false

  def confirm(person, hash)
    @subject    = '[turkopticon] Please confirm your email address'
    @body["hash"] = hash
    @recipients = person.email
    @from       = 'turkopticon@differenceengines.com'
    @bcc        = 'turkopticon@differenceengines.com' if @@send_bcc
    @sent_on    = Time.now
    @headers    = {}
  end

  def password_reset(person, new_password)
    @subject    = '[turkopticon] Your password was reset'
    @body["new_password"] = new_password
    @recipients = person.email
    @from       = 'turkopticon@differenceengines.com'
    @bcc        = 'turkopticon@differenceengines.com' if @@send_bcc
    @sent_on    = Time.now
    @headers    = {}
  end

  def password_change(person, new_password)
    @subject    = '[turkopticon] Your password was changed'
    @body["new_password"] = new_password
    @recipients = person.email
    @from       = 'turkopticon@differenceengines.com'
    @bcc        = 'turkopticon@differenceengines.com' if @@send_bcc
    @sent_on    = Time.now
    @headers    = {}
  end

end
