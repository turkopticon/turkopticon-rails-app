class Flag < ApplicationRecord
  belongs_to :person
  belongs_to :review

  validates :reason, presence: true
  serialize :activity, IndifferentJSON

  scope :newest, -> { order(created_at: :desc) }
  scope :status, -> (status) { where(open: status == :open ? true : false) }

  def modify(params, user_id)
    state                  = params[:open] && params[:open].to_bool
    self.open              = state unless state.nil?

    # TODO: tagging

    self.activity[:status] ||= []
    unless state.nil?
      self.activity[:status] << { status: state ? :reopened : :closed, by: user_id, at: Time.now }
    end

    save
  end

  def self.counts
    {
        open:   status(:open).count,
        closed: status(:closed).count
    }
  end
end