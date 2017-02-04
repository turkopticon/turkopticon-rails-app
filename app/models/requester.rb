class Requester < ApplicationRecord
  include PgSearch

  has_many :hits
  has_many :reviews, through: :hits

  validates :rid, presence: true, uniqueness: true
  validates :rname, presence: true
  serialize :aliases, Array

  # noinspection RubyResolve
  after_touch -> { Rails.cache.delete([self.class.name, 'rid', rid]) } # assume only rid uses find_by()

  pg_search_scope :name_search,
                  against: [[:rname, 'A'], [:aliases, 'B']],
                  using:   { tsearch: { dictionary: 'english', prefix: true } }

  def aggregates
    agg = { all: {}, recent: {} }

    [:all, :recent].each do |period|
      review = period == :all ? self.reviews.valid : self.reviews.recent.valid

      rewards = hits.map do |hit|
        hv = hit.reviews.valid.where('time > 0')
        [(hit.reward.to_f * hv.size).round(2), hv.sum(:time)]
      end

      agg[period][:reward]    = rewards.reduce([0, 0]) { |a, b| a[0] += b[0]; a[1] += b[1]; a } << review.where('time > 0').size
      agg[period][:reward][0] = agg[period][:reward][0].round(2)
      agg[period][:pending]   = review.average(:time_pending).to_f

      [:comm, :recommend].each do |key|
        n = review.where.not(key => 'n/a').size
        x = n > 0 && review.where(key => 'yes').size

        agg[period][key] = [n > 0 ? '%.f%%' % (100*x/n.to_f) : '--', n]
      end

      [:tos, :broken].each { |key| agg[period][key] = review.where(key => true).size }
    end

    agg
  end

  def manage_alias(name)
    if self.rname && self.rname != name
      self.aliases.push self.rname unless self.aliases.include? self.rname
    end
    self.rname = name
    self
  end

  def cached_aggregates
    Rails.cache.fetch([self.cache_key, 'aggregates']) { aggregates }
  end

  # def cached_multi_aggregates(sth)
  #   # Rails.cache.fetch_multi() {}
  # end

  def self.cached_find_by(opts = {})
    key = opts.keys[0]
    val = opts[key]
    Rails.cache.fetch([name, key.to_s, val]) { find_by(key => val) }
  end

  def self.cached_multi_find_by(opts = {})
    key = opts.keys[0].to_s
    val = opts[key.to_sym].map { |v| [name, key, v] }
    Rails.cache.fetch_multi(*val) { |ck| find_by(key => ck[2]) }
  end

end
