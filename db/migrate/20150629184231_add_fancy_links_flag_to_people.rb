class AddFancyLinksFlagToPeople < ActiveRecord::Migration
  def self.up
    add_column :people, :show_fancy_links, :boolean
  end

  def self.down
    remove_column :people, :show_fancy_links
  end
end
