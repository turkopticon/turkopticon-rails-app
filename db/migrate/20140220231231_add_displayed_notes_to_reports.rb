class AddDisplayedNotesToReports < ActiveRecord::Migration
  def self.up
    add_column :reports, :displayed_notes, :text
  end

  def self.down
    remove_column :reports, :displayed_notes
  end
end
