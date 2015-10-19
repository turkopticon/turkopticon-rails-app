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

  def update_replies
    if self.replies.nil?
      self.replies = 0
    end
    self.replies += 1
    last_reply = reply_posts.last
    self.last_reply_person_id = last_reply.person_id
    self.last_reply_display_name = last_reply.author_name
    self.save
  end

  def versions
    ForumPostVersion.find_all_by_post_id(self.id)
  end

  def version_count
    versions.count
  end

  def reply_posts
    ForumPost.find_all_by_thread_head(self.id)
  end

end
