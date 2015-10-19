class AddDeletedFlagToForumPosts < ActiveRecord::Migration
  def self.up
    add_column :forum_posts, :deleted, :boolean
  end

  def self.down
    remove_column :forum_posts, :deleted
  end
end
