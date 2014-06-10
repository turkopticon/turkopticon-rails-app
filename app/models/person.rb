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

  has_many :reports
  has_many :flags
  has_many :comments

  validates_presence_of :email
  validates_uniqueness_of :email
  validates_format_of :email, :with => /^([a-z0-9])([a-z0-9_\-\.\+])*(?!\.{2,})([a-z0-9])\@(?!mailinator|.*mial\.|spamcatch|spambob|spamavert|spamherelots)([a-z0-9])([a-z0-9\-\.])*\.([a-z]{2,4})$/i, :message => "is not a recognized email address"

  attr_accessor :password_confirmation
  #validates_presence_of :password
  validates_confirmation_of :password

  def toggle_my_reviews_order_flag
    if self.most_recent_first_in_my_reviews
      self.most_recent_first_in_my_reviews = false
    else
      self.most_recent_first_in_my_reviews = true
    end
    self.save
  end
  
  def before_validation
    self.email = self.email.downcase.strip
  end

  def validate
    errors.add_to_base("Missing password.") if hashed_password.blank?
  end

  def truncated_email
    begin
      e = email.split("@")
      f = e[0]
      g = e[1]
      dn = f[0,f.length/2] + "...@" + g[0,1] + "..."
    rescue Exception
      dn = email
    end
    dn
  end

  def public_email
    if display_name.nil?
      begin
        e = email.split("@")
        f = e[0]
        g = e[1]
        dn = f[0,f.length/2] + "...@" + g[0,1] + "..."
      rescue Exception
        dn = email
      end
    else
      dn = display_name.gsub(/[()]/,"")
    end
    dn += " (moderator)" if self.is_moderator
    dn
  end

  def mod_display_name
    dn = display_name.nil? ? email : display_name.gsub(/[()]/,"")
    if self.is_admin
      dn += " (admin)"
    else
      dn += " (moderator)" if self.is_moderator
    end
    dn
  end

  def recently_updated_report?
    rv = false
    t = Time.now
    reports.each{|r| rv = true if r.updated_at > (t - 1.month)}
    rv
  end

  def active?
    if reports.blank?
      false
    elsif recently_updated_report?
      true
    else
      false
    end
  end

  def inactive?
    !active?
  end

  def self.active_count
    rv = 0
    Person.find(:all).each{|p| rv += 1 if p.active?}
    rv
  end

	def self.authenticate(email, password)
		person = self.find_by_email(email)
	 	if person
	   	expected_password = encrypted_password(password, person.salt)
	   	if person.hashed_password != expected_password
				person = nil
			end
		end
		person
	end

	def password
		@password
	end

  def password=(pwd)
    if pwd.nil? or pwd.length == 0
      self.salt = nil
      self.hashed_password = nil
    else
      @password = pwd
      create_new_salt
      self.hashed_password = Person.encrypted_password(self.password, self.salt)
    end
  end
	
	private

	def self.encrypted_password(password, salt)
		string_to_hash = password + "foos" + salt
		Digest::SHA1.hexdigest(string_to_hash)
	end

	def create_new_salt
		self.salt = self.object_id.to_s + rand.to_s
	end

end
