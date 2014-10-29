class AddOrderByFlagToPeople < ActiveRecord::Migration
  def self.up
    add_column :people, :order_reviews_by_edit_date, :boolean
  end

  def self.down
    remove_column :people, :order_reviews_by_edit_date
  end
end
