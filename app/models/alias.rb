# == Schema Information
# Schema version: 20140610175616
#
# Table name: aliases
#
#  id           :integer(4)      not null, primary key
#  requester_id :integer(4)
#  formerly     :integer(4)
#  created_at   :datetime
#  updated_at   :datetime
#

class Alias < ActiveRecord::Base
end
