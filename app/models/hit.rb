class Hit < ApplicationRecord
  belongs_to :requester
  has_many :reviews

  validates :title, presence: true
  validates :reward, presence: true, numericality: true
end
