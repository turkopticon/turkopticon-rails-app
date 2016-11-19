class Requester < ApplicationRecord
  has_many :hits
  has_many :reviews, through: :hits

  validates :rid, presence: true, uniqueness: true
  validates :rname, presence: true
  serialize :aliases, Array

  # default_scope { includes(hits: [{ reviews: [:person, :comments] }]) }
  scope :by_rid, -> (rid) { includes(:hits).where(rid: rid).take }

  def aggregates
    agg    = { all: {}, recent: {} }
    av, rv = self.reviews.valid, self.reviews.recent.valid

    reward             = self.hits.map { |h| hv = h.reviews.valid; [h.reward.to_f * hv.count(:time), hv.sum(:time)] }
    agg[:all][:reward] = reward.reduce([0, 0]) { |a, b| a[0] += b[0]; a[1] += b[1]; a }

    reward                = self.hits.map { |h| hv = h.reviews.recent.valid; [h.reward.to_f * hv.count(:time), hv.sum(:time)] }
    agg[:recent][:reward] = reward.reduce([0, 0]) { |a, b| a[0] += b[0]; a[1] += b[1]; a }

    agg[:all][:pending]    = av.average(:time_pending)
    agg[:recent][:pending] = rv.average(:time_pending)

    [:comm, :recommend].each do |k|
      n            = av.where.not(k => 'n/a').count
      x            = n > 0 && av.where(k => 'yes').count
      agg[:all][k] = [n > 0 ? '%.f%%' % (100*x/n.to_f) : '--', n]

      n               = rv.where.not(k => 'n/a').count
      x               = n > 0 && rv.where(k => 'yes').count
      agg[:recent][k] = [n > 0 ? '%.f%%' % (100*x/n.to_f) : '--', n]
    end

    [:tos, :broken, :deceptive].each do |k|
      agg[:all][k]    = av.where(k => true).count
      agg[:recent][k] = rv.where(k => true).count
    end

    agg
  end

  def manage_alias(name)
    if self.rname != name
      self.aliases.push self.rname unless self.aliases.include? self.rname
      self.rname = name
    end
    self
  end

end
