class AdminMailer < ActionMailer::Base

  @@send_bcc = true

  def enabled(person)
    @subject    = '[turkopticon] Commenting enabled'
    @recipients = person.email
    @from       = 'turkopticon@ucsd.edu'
    @bcc        = 'turkopticon.maint@gmail.com' if @@send_bcc
    @sent_on    = Time.now
    @headers    = {}
  end

  def declined(person)
    @subject    = '[turkopticon] Commenting request declined for now'
    @recipients = person.email
    @from       = 'turkopticon@ucsd.edu'
    @bcc        = 'turkopticon.maint@gmail.com' if @@send_bcc
    @sent_on    = Time.now
    @headers    = {}
  end

  def report(out)
    @subject    = '[turkopticon] Commenting requests reviewed'
    @recipients = 'silberman.six@gmail.com'
    @body["report"] = out
    @from       = 'turkopticon@ucsd.edu'
    @bcc        = 'turkopticon.maint@gmail.com' if @@send_bcc
    @sent_on    = Time.now
    @headers    = {}
  end

end
