class AddOldNameToRequesters < ActiveRecord::Migration
  def self.up
    add_column :requesters, :old_name, :string
  end

  def self.down
    remove_column :requesters, :old_name
  end
end
