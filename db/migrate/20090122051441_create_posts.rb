class CreatePosts < ActiveRecord::Migration
  def self.up
    create_table :posts do |t|
      t.integer :person_id
      t.integer :parent_id
      t.text :title
      t.text :body

      t.timestamps
    end
  end

  def self.down
    drop_table :posts
  end
end
