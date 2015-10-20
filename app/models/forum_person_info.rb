class ForumPersonInfo < ActiveRecord::Base
  self.set_table_name "forum_person_info"

  def up_effect
    self.initialize_karma
    self.karma
  end

  def down_effect
    self.initialize_karma
    -1 * self.karma
  end

  def initialize_karma
    if self.karma.nil?
      self.karma = 1
      self.save
    end
  end

end
