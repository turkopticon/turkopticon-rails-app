class AddApproveRejectInfoFieldsToRequestersTableForApi < ActiveRecord::Migration
  def self.up
    add_column :requesters, :all_rejected, :integer
    add_column :requesters, :some_rejected, :integer
    add_column :requesters, :all_approved_or_pending, :integer
    add_column :requesters, :all_pending_or_didnt_do_hits, :integer
  end

  def self.down
    remove_column :requesters, :all_rejected
    remove_column :requesters, :some_rejected
    remove_column :requesters, :all_approved_or_pending
    remove_column :requesters, :all_pending_or_didnt_do_hits
  end
end
