class CreateFlags < ActiveRecord::Migration
  def self.up
    create_table :flags do |t|
      t.integer :report_id
      t.integer :person_id
      t.text :comment

      t.timestamps
    end
  end

  def self.down
    drop_table :flags
  end
end
