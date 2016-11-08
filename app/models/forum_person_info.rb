class ForumPersonInfo < ActiveRecord::Base
  self.table_name = 'forum_person_info'

  def up_effect
    self.initialize_karma
    self.karma < 0.0 ? 0.0 : self.karma
  end

  def down_effect
    self.initialize_karma
    self.karma < 0.0 ? 0.0 : -1.0 * self.karma
  end

  def initialize_karma
    if self.karma.nil?
      self.karma = 1
      self.save
    end
  end

end
