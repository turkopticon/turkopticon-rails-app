class Flag < ApplicationRecord
  belongs_to :person
  belongs_to :review

  validates :reason, presence: true

  scope :newest, -> { order(created_at: :desc) }
  scope :open, -> { where(open: true) }
  scope :closed, -> { where(open: false) }
end