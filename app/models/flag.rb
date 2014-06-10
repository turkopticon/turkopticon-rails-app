# == Schema Information
# Schema version: 20140610175616
#
# Table name: flags
#
#  id              :integer(4)      not null, primary key
#  report_id       :integer(4)
#  person_id       :integer(4)
#  comment         :text
#  created_at      :datetime
#  updated_at      :datetime
#  displayed_notes :text
#

class Flag < ActiveRecord::Base

  belongs_to :person
  belongs_to :report

  validates_presence_of :comment

  def convert_to_comment
    note = "\n\n<span class='edit_note'>This comment used to be a flag. "
    note += "It was converted by the author at "
    note += Time.now.strftime("%l:%M %p %b %d %Y %Z") + ".</span>"
    rid = self.report_id
    Comment.new(:report_id => self.report_id,
                :person_id => self.person_id,
                :body => self.comment + note,
                :created_at => self.created_at).save
    self.destroy
    Report.find(rid).update_flag_data
  end

end
