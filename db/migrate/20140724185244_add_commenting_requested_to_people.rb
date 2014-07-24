class AddCommentingRequestedToPeople < ActiveRecord::Migration
  def self.up
    add_column :people, :commenting_requested, :boolean
  end

  def self.down
    remove_column :people, :commenting_requested
  end
end
