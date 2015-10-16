class ForumPost < ActiveRecord::Base

  def current_version
    ForumPostVersion.find_by_post_id_and_next(self.id, nil)
  end

  def title
    current_version.title
  end

  def author_name
    Person.find(self.person_id).public_email
  end

  def body
    current_version.body
  end

  def increment_views
    if self.views.nil?
      self.views = 0
    end
    self.views +=1
    self.save
  end

end
