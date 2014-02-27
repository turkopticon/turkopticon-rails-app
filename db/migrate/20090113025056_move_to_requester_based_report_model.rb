class MoveToRequesterBasedReportModel < ActiveRecord::Migration
  def self.up
    add_column :reports, :how_many_hits, :string
    add_column :reports, :fair, :integer
    add_column :reports, :fast, :integer
    add_column :reports, :pay, :integer
    add_column :reports, :comm, :integer
  end

  def self.down
    remove_column :reports, :how_many_hits
    remove_column :reports, :fair
    remove_column :reports, :fast
    remove_column :reports, :pay
    remove_column :reports, :comm
  end
end
