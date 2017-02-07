class AddIpToReviews < ActiveRecord::Migration[5.0]
  def change
    add_column :reviews, :ip, :inet
    add_index :reviews, :ip
  end
end
