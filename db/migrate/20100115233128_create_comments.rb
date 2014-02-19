class CreateComments < ActiveRecord::Migration
  def self.up
    create_table :comments do |t|
      t.integer :report_id
      t.integer :person_id
      t.text :body

      t.timestamps
    end
  end

  def self.down
    drop_table :comments
  end
end
