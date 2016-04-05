class CreateRulesVersions < ActiveRecord::Migration
  def self.up
    create_table :rules_versions do |t|
      t.integer :parent_id
      t.boolean :is_current
      t.integer :edited_by_person_id

      t.timestamps
    end
  end

  def self.down
    drop_table :rules_versions
  end
end
