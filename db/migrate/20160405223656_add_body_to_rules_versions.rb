class AddBodyToRulesVersions < ActiveRecord::Migration
  def self.up
    add_column :rules_versions, :body, :text
  end

  def self.down
    remove_column :rules_versions
  end
end
