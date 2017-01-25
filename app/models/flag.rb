class Flag < ApplicationRecord
  belongs_to :person
  belongs_to :review

  validates :reason, presence: true
end