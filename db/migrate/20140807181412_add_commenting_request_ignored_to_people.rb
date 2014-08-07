class AddCommentingRequestIgnoredToPeople < ActiveRecord::Migration
  def self.up
    add_column :people, :commenting_request_ignored, :boolean
  end

  def self.down
    remove_column :people,:commenting_request_ignored
  end
end
