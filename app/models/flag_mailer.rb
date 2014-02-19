class FlagMailer < ActionMailer::Base

  def notify(report_id, comment)
    @subject    = '[turkopticon] Flag raised'
    @body["report_id"] = report_id
    @body["comment"] = comment
    @body["requester_name"] = Report.find(report_id).requester_amzn_name
    @body["requester_id"] = Report.find(report_id).requester_amzn_id
    @recipients = 'six.silberman@gmail.com', 'lilly.irani@gmail.com'
    @from       = 'turkopticon@differenceengines.com'
    @bcc        = 'turkopticon@differenceengines.com'
    @sent_on    = Time.now
    @headers    = {}
  end  

end
