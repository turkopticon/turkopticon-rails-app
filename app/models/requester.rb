class Requester < ApplicationRecord
  has_many :hits
  has_many :reviews, through: :hits

  validates :rid, uniqueness: true
  serialize :aliases, Array
end
