# == Schema Information
# Schema version: 20140610175616
#
# Table name: reports
#
#  id                  :integer(4)      not null, primary key
#  person_id           :integer(4)
#  requester_id        :integer(4)
#  hit_id              :string(255)
#  description         :text
#  created_at          :datetime
#  updated_at          :datetime
#  how_many_hits       :string(255)
#  fair                :integer(4)
#  fast                :integer(4)
#  pay                 :integer(4)
#  comm                :integer(4)
#  is_flagged          :boolean(1)
#  is_hidden           :boolean(1)
#  tos_viol            :boolean(1)
#  amzn_requester_id   :string(255)
#  displayed_notes     :text
#  amzn_requester_name :string(255)
#  flag_count          :integer(4)
#  comment_count       :integer(4)
#

require 'acts_as_ferret'

class Report < ActiveRecord::Base

  belongs_to :person
  belongs_to :requester
  has_many :flags
  has_many :comments
  has_many :ignores
  acts_as_ferret(:fields => [:description],
                 :ferret => {:use_compound_file => true,
                             :merge_factor => 4})

  def before_save
    self.disable_ferret(:always)
  end

  def update_flag_data
    nflags = flags.length
    mod_flagged = false
    flags.each{|f| mod_flagged = true if f.person.is_moderator}
    if mod_flagged and nflags > 1 and flags.first.person_id != flags.last.person_id
      self.is_hidden = true
    else
      self.is_hidden = nil
    end
    if nflags > 0
      self.is_flagged = true
    else
      self.is_flagged = nil
    end
    self.save
  end

  def print_h
    r = "id: " + id.to_s
    r += ", person_id: " + person_id.to_s
    r += ", person_email: " + person.email
    r += ", requester_id: " + requester_id.to_s
    r += ", requester_name: " + requester.amzn_requester_name unless requester_id.nil?
    r += ", description: '" + description + "'"
    r += ", fair: " + fair.to_s
    r += ", fast: " + fast.to_s
    r += ", pay: " + pay.to_s
    r += ", comm: " + comm.to_s
  end

  def requester_amzn_id
    requester.nil? ? "" : requester.amzn_requester_id
  end

  def requester_amzn_name
    if amzn_requester_name.nil?
      requester.nil? ? "" : requester.amzn_requester_name
    else
      amzn_requester_name
    end
  end

  def self.requester_attrs
    ["fair", "fast", "pay", "comm"]
  end

  def self.question(attr)
    case attr
      when "fair"
        "How fair has this requester been in approving or rejecting your work?"
      when "fast"
        "How promptly has this requester approved your work and paid?"
      when "pay"
        "How well has this requester paid for the amount of time their HITs take?"
      when "comm"
        "How responsive has this requester been to communications or concerns you have raised?"
    end
  end

  def self.how_many_hits_ranges
    ["None", "1 - 5", "6 - 20", "21 - 100", "101+"]
  end

end

class String
  def censor
    self.gsub(/[^A-Za-z]ass[^A-Za-z]|asshole|jackass|retard/i,"[rearward-facing primate orifice]").gsub(/fck|fuck|[^A-Za-z]cunt[^A-Za-z]|shit|douche|bitch|nigger|dick/i,"[delightful bamboo-eating panda]").gsub(/faggot|[^A-Za-z]fag[^A-Za-z]|phaggot|idiot|mofo/i,"[the person I love the most]").gsub(/dumb|asinine|stupid/i,"[inspiring]")
  end
end
