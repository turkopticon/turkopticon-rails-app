class CreateIgnores < ActiveRecord::Migration
  def self.up
    create_table :ignores do |t|
      t.integer :person_id
      t.integer :report_id
      t.timestamps
    end
  end

  def self.down
    drop_table :ignores
  end
end
