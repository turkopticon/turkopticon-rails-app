class Requester < ApplicationRecord
  self.primary_key = 'rid'
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

    # TODO: optimize

    [:all, :recent].each do |period|
      review = period == :all ? self.reviews.valid : self.reviews.recent.valid
      total  = review.size
      revt    = review.where 'time > 0'
      rewards = revt.map { |rev| [rev.hit.reward.to_f, rev.time] }

      agg[period][:reward]    = rewards.reduce([0, 0]) { |a, b| a[0] += b[0]; a[1] += b[1]; a } << revt.size
      agg[period][:reward][0] = agg[period][:reward][0].round(2)
      agg[period][:pending]   = review.average(:time_pending).to_f

      [:comm, :recommend, :rejected].each do |key|
        n                = review.where.not(key => 'n/a').size
        x = n > 0 ? review.where(key => 'yes').size : 0

        agg[period][key] = [x, n, total]
      end

      [:tos, :broken].each { |key| agg[period][key] = [review.where(key => true).size, total] }
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
    Rails.cache.fetch([self.cache_key, 'aggregates'], expires_in: (Time.now.end_of_day - Time.now).to_i) { aggregates }
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
