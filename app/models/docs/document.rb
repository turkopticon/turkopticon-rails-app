class Docs::Document < ApplicationRecord
  has_many :versions, class_name: 'Docs::Version'

  validates :name, uniqueness: true, presence: true
  validates :title, presence: true
  validates :body, presence: true

  def save_doc(attrs)
    self.assign_attributes attrs
    save!
    Docs::Version.create! attrs.merge(document: self)
  end

end