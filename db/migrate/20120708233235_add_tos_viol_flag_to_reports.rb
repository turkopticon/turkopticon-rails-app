class AddTosViolFlagToReports < ActiveRecord::Migration
  def self.up
    add_column :reports, :tos_viol, :boolean
  end

  def self.down
    remove_column :reports, :tos_viol
  end
end
