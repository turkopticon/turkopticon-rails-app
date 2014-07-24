class AddIgnoresToReports < ActiveRecord::Migration
  def self.up
    add_column :reports, :ignores, :integer, :default => 0
  end

  def self.down
    remove_column :reports, :ignores
  end
end
