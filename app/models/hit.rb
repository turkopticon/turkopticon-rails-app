class Hit < ApplicationRecord
  belongs_to :requester, touch: true
  has_many :reviews

  validates :title, presence: true
  validates :reward, presence: true, numericality: true
end
