class Hit < ApplicationRecord
  belongs_to :requester, touch: true
  has_many :reviews

  accepts_nested_attributes_for :requester

  validates :title, presence: true
  validates :reward, presence: true, numericality: true

  def requester_attributes=(attrs)
    (self.requester = Requester.find_by(rid: attrs[:rid])) || self.build_requester.update(attrs)
    self.requester.update(attrs) unless self.requester[:name] == attrs[:name]
  end
end
