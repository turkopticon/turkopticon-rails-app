class AddAvaAndNrsToRequesters < ActiveRecord::Migration
  def self.up
    add_column :requesters, :ava, :decimal, :precision => 3, :scale => 2
    add_column :requesters, :nrs, :integer
  end

  def self.down
    remove_column :requesters, :ava
    remove_column :requesters, :nrs
  end
end
