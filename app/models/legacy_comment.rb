# == Schema Information
# Schema version: 20140610175616
#
# Table name: comments
#
#  id              :integer(4)      not null, primary key
#  report_id       :integer(4)
#  person_id       :integer(4)
#  body            :text
#  created_at      :datetime
#  updated_at      :datetime
#  notes           :text
#  displayed_notes :text
#

class LegacyComment < ActiveRecord::Base

  belongs_to :person
  belongs_to :report
  validates_presence_of :body

end
