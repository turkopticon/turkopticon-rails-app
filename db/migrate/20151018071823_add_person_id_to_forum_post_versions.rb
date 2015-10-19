class AddPersonIdToForumPostVersions < ActiveRecord::Migration
  def self.up
    add_column :forum_post_versions, :person_id, :integer
  end

  def self.down
    remove_column :forum_post_versions, :person_id
  end
end
