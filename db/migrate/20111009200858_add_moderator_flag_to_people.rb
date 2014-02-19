class AddModeratorFlagToPeople < ActiveRecord::Migration
  def self.up
    add_column :people, :is_moderator, :boolean
  end

  def self.down
    remove_column :people, :is_moderator
  end
end
