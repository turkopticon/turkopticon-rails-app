class AddDisplayNameToPeople < ActiveRecord::Migration
  def self.up
    add_column :people, :display_name, :string
  end

  def self.down
    remove_column :people, :display_name
  end
end
