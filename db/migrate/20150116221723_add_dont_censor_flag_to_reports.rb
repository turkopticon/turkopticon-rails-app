class AddDontCensorFlagToReports < ActiveRecord::Migration
  def self.up
    add_column :reports, :dont_censor, :boolean
  end

  def self.down
    remove_column :reports, :dont_censor
  end
end
