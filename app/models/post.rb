# == Schema Information
# Schema version: 20130604141843
#
# Table name: posts
#
#  id         :integer(4)      not null, primary key
#  person_id  :integer(4)
#  parent_id  :integer(4)
#  title      :text
#  body       :text
#  created_at :datetime
#  updated_at :datetime
#  slug       :string(255)
#

class Post < ActiveRecord::Base

  def children
    Post.find_all_by_parent_id(id)
  end

  def parent
    Post.find(parent_id)
  end

  def author_email
    Person.find(person_id).public_email
  end

end
