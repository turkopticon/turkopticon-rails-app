# == Schema Information
# Schema version: 20140610175616
#
# Table name: requesters
#
#  id                  :integer(4)      not null, primary key
#  amzn_requester_id   :string(255)
#  amzn_requester_name :string(255)
#  created_at          :datetime
#  updated_at          :datetime
#  ava                 :decimal(3, 2)
#  nrs                 :integer(4)
#  av_comm             :decimal(3, 2)
#  av_pay              :decimal(3, 2)
#  av_fair             :decimal(3, 2)
#  av_fast             :decimal(3, 2)
#  tos_flags           :integer(4)
#  old_name            :string(255)
#

# require 'ruport'
class LegacyRequester < ActiveRecord::Base

#  validates_presence_of :amzn_requester_id
#  validates_uniqueness_of :amzn_requester_id

  has_many :reports #, class_name: 'Report', foreign_key: 'requester_id'
  has_many :flags, :through => :reports

  def has_hidden_reports?
    hidden_report_count > 0
  end

  def hidden_report_count
    reports.select{|r| r.is_hidden}.length
  end

  def report_count
    reports.length
  end

  def reporter_count
    reports.collect{|r| r.person_id}.uniq.length
  end

  def comm
    Report.find(:all, :conditions => {:requester_id => id, :is_hidden => nil}).collect{|r| r.comm}.compact.delete_if{|i| i == 0}.mean
  end

  def pay
    Report.find(:all, :conditions => {:requester_id => id, :is_hidden => nil}).collect{|r| r.pay}.compact.delete_if{|i| i == 0}.mean
  end

  def fair
    Report.find(:all, :conditions => {:requester_id => id, :is_hidden => nil}).collect{|r| r.fair}.compact.delete_if{|i| i == 0}.mean
  end

  def fast
    Report.find(:all, :conditions => {:requester_id => id, :is_hidden => nil}).collect{|r| r.fast}.compact.delete_if{|i| i == 0}.mean
  end

  def avg_attrs
    attrs = {}
    Report.requester_attrs.each{|a|
      attrs[a] = Report.find(:all, :conditions => {:requester_id => id}).delete_if{|r| r.is_hidden}.collect{|r| eval("r." + a)}.compact.delete_if{|i| i == 0}.mean
      # pre-hiding version below
      # attrs[a] = Report.find(:all, :conditions => {:requester_id => id}).collect{|r| eval("r." + a)}.compact.delete_if{|i| i == 0}.mean
    }
    attrs
  end

  def avg_attrs_avg
    avg_attrs.values.delete_if{|i| i == 0}.mean
  end

  def attrs_text
    retstr = ""
    for a,v in avg_attrs
      retstr += attr_word(a) + ": " + Requester.attr_vis(v) + " " + sprintf("%0.02f", v) + " / 5<br/>"
    end
    retstr += "<br><FONT FACE='Verdana, Arial' size=2><u>THIS VERSION OF TURKOPTICON IS NOW OUTDATED</u><br> - Please click <a href='#' onclick='InstallTrigger.install({\"Turkopticon\":\"https://www.stanford.edu/group/experiment/cgi-bin/turkopticon/firefox/turkopticon.xpi\"});'>here</a> to install the new version<br>(you will need to press 'allow' and accept the changes).<br>Click <a href='http://turkopticon.differenceengines.com/main/install_v2'>here</a> for information about the new version.</font><br>"	 
    retstr += "numReports:" + report_count.to_s
  end

  def attrs_text_2
    retstr = ""
    retstr += "avg:" + avg_attrs_avg.round(2).to_s + "<br/>#"
    for a,v in avg_attrs
      retstr += attr_word(a) + ": " + Requester.attr_vis(v) + " " + sprintf("%0\
.02f", v) + " / 5<br/>"
    end
    retstr += "numReports:" + report_count.to_s
  end
  
  def attrs_text_v2
      retstr = ""
    for a,v in avg_attrs
      retstr += attr_word(a) + ": " + Requester.attr_vis(v) + " " + sprintf("%0.02f", v) + " / 5<br/>"
    end 
    retstr += "numReports:" + report_count.to_s
  end


  def attr_word(a)
    case a
      when "pay" then  "generosity&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"
      when "fair" then "fairness&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"
      when "fast" then "promptness&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"
      when "comm" then "communicativity"
    end
  end

  def self.attr_vis(v)  # value "v" should be a decimal in [1.0,vmax]
    vmax = 5.0
    if v.nil?
      v = 0.0
    end
    redflag = v <= 2.0 ? "id='red'" : v <= 3.0 ? "id='yellow'" : ""
    spch = 30  # number of total &nbsp; characters in meter
    retstr = "<span class='progress-meter'><span class='progress-meter-done' #{redflag}>"
    donefrac = v / vmax
    ndone = donefrac * spch
    ndone = ndone.round
    ndone.times do
      retstr.concat("&nbsp;")
    end
    retstr.concat("</span><span class='progress-meter-undone'>")
    undone = spch - ndone
    undone.times do
      retstr.concat("&nbsp;")
    end
    retstr.concat("</span></span>")
    retstr
  end

  def cache_columns
    self.av_comm = comm
    self.av_pay = pay
    self.av_fair = fair
    self.av_fast = fast
    self.tos_flags = reports.select{|r| r.tos_viol}.length
    self.ava = avg_attrs_avg
    self.nrs = report_count

    self.all_rejected = reports.select{|rep| rep.rejected == "yes"}.length
    self.some_rejected = reports.select{|rep| rep.rejected == "some"}.length
    self.all_approved_or_pending = reports.select{|rep| rep.rejected == "no"}.length
    self.all_pending_or_didnt_do_hits = reports.select{|rep| rep.rejected == "n/a"}.length

    self.save
  end

end

class Array
  def mean
    if self.length == 0
      0
    else
      self.inject{|sum, n| sum + n} / self.length.to_f
    end
  end
end
