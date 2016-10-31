class Review < ApplicationRecord
  belongs_to :hit
  belongs_to :person
  has_one :requester, through: :hit
  has_many :comments
end
