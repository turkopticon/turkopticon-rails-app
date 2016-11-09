# == Schema Information
# Schema version: 20140610175616
#
# Table name: people
#
#  id                              :integer(4)      not null, primary key
#  email                           :string(255)
#  hashed_password                 :string(255)
#  salt                            :string(255)
#  email_verified                  :boolean(1)
#  created_at                      :datetime
#  updated_at                      :datetime
#  is_admin                        :boolean(1)
#  display_name                    :string(255)
#  is_moderator                    :boolean(1)
#  is_closed                       :boolean(1)
#  closed_at                       :datetime
#  most_recent_first_in_my_reviews :boolean(1)
#

class Person < ActiveRecord::Base

  has_many :reports #legacy reviews
  has_many :reviews
  has_many :comments
  has_many :flags
  has_many :legacy_comments
  has_many :ignores

  before_validation { |r| r.email = r.email.downcase.strip }

  validates :email, presence: true, uniqueness: true, format: {
      with:    /\A([a-z0-9])([a-z0-9_\-\.\+])*(?!\.{2,})([a-z0-9])\@(?!mailinator|.*mial\.|spamcatch|spambob|spamavert|spamherelots)([a-z0-9])([a-z0-9\-\.])*\.([a-z]{2,4})\z/i,
      message: 'is not a recognized email address' }

  validates :password, presence: true, confirmation: true
  validates :password_confirmation, presence: true

  def verify
    self.update_attributes(:email_verified => true)
  end

  def verified?
    self.email_verified?
  end

  def close
    self.update_attributes(:is_closed => true, :closed_at => Time.now)
  end

  def toggle_order_by_flag
    if self.order_reviews_by_edit_date
      self.order_reviews_by_edit_date = false
    else
      self.order_reviews_by_edit_date = true
    end
    self.save
  end

  def toggle_my_reviews_order_flag
    if self.most_recent_first_in_my_reviews
      self.most_recent_first_in_my_reviews = false
    else
      self.most_recent_first_in_my_reviews = true
    end
    self.save
  end

  # TODO: probably doesn't belong in the model; refactor all display name stuff into a view helper
  def truncated_email
    begin
      e  = email.split("@")
      f  = e[0]
      g  = e[1]
      dn = f[0, f.length/2] + "...@" + g[0, 1] + "..."
    rescue Exception
      dn = email
    end
    dn
  end

  def public_email
    if display_name.nil?
      begin
        e  = email.split("@")
        f  = e[0]
        g  = e[1]
        dn = f[0, f.length/2] + "...@" + g[0, 1] + "..."
      rescue Exception
        dn = email
      end
    else
      dn = display_name.empty? ? id.to_s : display_name.gsub(/[()]/, '')
    end
    if self.is_admin
      dn << ' (admin)'
    elsif self.is_moderator
      dn << ' (moderator)'
    end
    dn
  end

  def mod_display_name
    dn = display_name.nil? ? email : display_name.gsub(/[()]/, "")
    dn = id.to_s if dn.empty?
    if self.is_admin
      dn += " (admin)"
    else
      dn += " (moderator)" if self.is_moderator
    end
    dn
  end

  def recently_updated_review?
    reviews.where('updated_at > ?', 1.month.ago).size > 0
  end

  def active?
    reviews.empty? ? false : recently_updated_review?
  end

  def inactive?
    !active?
  end

  def self.active_count
    self.joins(:reviews).where('reviews.updated_at > ?', 1.month.ago).size
  end

  def authenticate(password)
    expected_password = encrypted_password(password, self.salt)
    self.hashed_password == expected_password
  end

  def password
    @password
  end

  def password=(pwd)
    if pwd.nil? or pwd.length == 0
      self.salt            = nil
      self.hashed_password = nil
    else
      @password = pwd
      create_new_salt
      self.hashed_password = encrypted_password(self.password, self.salt)
    end
  end

  private

  def encrypted_password(password, salt)
    string_to_hash = password + "foos" + salt
    Digest::SHA1.hexdigest(string_to_hash)
  end

  def create_new_salt
    self.salt = self.object_id.to_s + rand.to_s
  end

end
