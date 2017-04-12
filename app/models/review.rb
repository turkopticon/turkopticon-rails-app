class Review < ApplicationRecord
  belongs_to :hit, touch: true
  belongs_to :person
  has_one :requester, through: :hit
  has_many :comments
  has_many :flags

  accepts_nested_attributes_for :hit

  default_scope { includes(:requester, :hit, :person) }
  scope :newest, -> { order(created_at: :desc) }
  scope :of_requester, -> (rid) { where('requesters.rid': rid) }
  scope :by_user, -> (id) { where(person_id: id) }
  scope :valid, -> { where(valid_review: true) }
  scope :recent, -> (frame = (90.days.ago .. Time.now)) { where(created_at: frame) }
  # scope :with, -> (*args) { joins(*args) }


  def tags
    tags = %w( tos broken recommend )
               .map { |t| [t, self[t], self["#{t}_context"]] }
               .select { |t| t[1] == true || t[1] =~ /(no|yes)/ || t[1] == 1 }
    tags.unshift ['rejected', true, 'some or all of my work was rejected'] if self.rejected?
    tags
  end

  def rejected?
    self[:rejected] == 'all' || self[:rejected] == 'some'
  end

  def hit_attributes=(attrs)
    query = { requester_id: attrs[:requester_attributes][:rid], title: attrs[:title], reward: attrs[:reward] }
    (self.hit = Hit.find_by(query)) || self.build_hit.update(attrs)
  end

end
