class CreateAliases < ActiveRecord::Migration
  def self.up
    create_table :aliases do |t|
      t.integer :requester_id
      t.integer :formerly

      t.timestamps
    end
  end

  def self.down
    drop_table :aliases
  end
end
