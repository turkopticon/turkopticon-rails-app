class Hit < ApplicationRecord
  belongs_to :requester
  has_many :reviews
end
