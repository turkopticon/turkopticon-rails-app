class AddCommentingFlagToPeople < ActiveRecord::Migration
  def self.up
    add_column :people, :can_comment, :boolean
  end

  def self.down
    remove_column :people, :can_comment
  end
end
