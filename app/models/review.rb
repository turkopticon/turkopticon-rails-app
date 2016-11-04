class Review < ApplicationRecord
  belongs_to :hit
  belongs_to :person
  has_one :requester, through: :hit
  has_many :comments

  attr_writer :dependent_params

  default_scope { includes(:requester, :hit, :person) }
  scope :newest, -> (max) { order(created_at: :desc).limit(max) }
  scope :of_requester, -> (rid) { where('requesters.rid': rid) }
  scope :by_user, -> (id) { where(person_id: id) }
  scope :valid, -> { where(valid_review: true) }
  scope :recent, -> (frame = (90.days.ago .. Time.now)) { where(created_at: frame) }
  # scope :with, -> (*args) { joins(*args) }

  before_validation :dont_orphan_me_bro

  def tags
    tags = %w( tos broken deceptive recommend )
               .map { |t| [t, self[t], self["#{t}_context"]] }
               .select { |t| t[1] == true || t[1] =~ '(no|yes)' }
    tags.unshift ['rejected', true, 'some or all of my work was rejected'] if self.rejected == 'yes'
    tags
  end

  private

  def dont_orphan_me_bro
    params = @dependent_params || {}
    person = Person.find(params[:user])
    req    = Requester.find_or_initialize_by(rid: params[:rid]).manage_alias(params[:rname])
    req.save
    hit            = Hit.find_or_create_by!(title: params[:title], reward: params[:reward], requester_id: req.id)
    self.person    = person
    self.requester = req
    self.hit       = hit
  end

end
