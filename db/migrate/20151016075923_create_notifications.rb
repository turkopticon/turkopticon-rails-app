class CreateNotifications < ActiveRecord::Migration
  def self.up
    create_table :notifications do |t|
      t.integer :person_id
      t.text :title
      t.text :body
      t.boolean :read
      t.datetime :read_at
      t.timestamps
    end
  end

  def self.down
    drop_table :notifications
  end
end
