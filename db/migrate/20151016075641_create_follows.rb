class CreateFollows < ActiveRecord::Migration
  def self.up
    create_table :follows do |t|
      t.integer :person_id
      t.string :follow_type
      t.integer :follow_id
      t.timestamps
    end
  end

  def self.down
    drop_table :follows
  end
end