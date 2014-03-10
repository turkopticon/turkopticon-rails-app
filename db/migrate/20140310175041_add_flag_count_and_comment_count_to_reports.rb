class AddFlagCountAndCommentCountToReports < ActiveRecord::Migration
  def self.up
    add_column :reports, :flag_count, :integer
    add_column :reports, :comment_count, :integer
  end

  def self.down
    remove_column :reports, :flag_count
    remove_column :reports, :comment_count
  end
end
