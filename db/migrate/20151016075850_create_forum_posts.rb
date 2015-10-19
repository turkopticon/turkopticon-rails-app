class CreateForumPosts < ActiveRecord::Migration
  def self.up
    create_table :forum_posts do |t|
      t.integer :person_id
      t.integer :parent_id
      t.string :slug
      t.boolean :sticky
      t.decimal :score, :precision => 5, :scale => 2
      t.integer :replies
      t.integer :views
      t.string :last_reply_display_name
      t.string :last_reply_person_id
      t.integer :last_reply_id
      t.datetime :last_reply_at
      t.timestamps
    end
  end

  def self.down
    drop_table :forum_posts
  end
end
