class Review < ApplicationRecord
  belongs_to :hit
  has_one :requester, through: :hit
  has_many :comments
end
