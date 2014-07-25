class RenameIgnoresToIgnoreCountInReports < ActiveRecord::Migration
  def self.up
    rename_column :reports, :ignores, :ignore_count
  end

  def self.down
    renamce_column :reports, :ignore_count, :ignores
  end
end
