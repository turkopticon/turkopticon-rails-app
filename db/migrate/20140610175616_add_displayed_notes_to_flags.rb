class AddDisplayedNotesToFlags < ActiveRecord::Migration
  def self.up
    add_column :flags, :displayed_notes, :text
  end

  def self.down
    remove_column :flags, :displayed_notes
  end
end
