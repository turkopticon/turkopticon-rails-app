# == Schema Information
# Schema version: 20130604141843
#
# Table name: comments
#
#  id         :integer(4)      not null, primary key
#  report_id  :integer(4)
#  person_id  :integer(4)
#  body       :text
#  created_at :datetime
#  updated_at :datetime
#  notes      :text
#

class Comment < ActiveRecord::Base

  belongs_to :person
  belongs_to :report

end
