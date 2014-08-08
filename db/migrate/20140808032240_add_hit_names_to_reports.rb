class AddHitNamesToReports < ActiveRecord::Migration
  def self.up
    add_column :reports, :hit_names, :text
  end

  def self.down
    remove_column :reports, :hit_names
  end
end
