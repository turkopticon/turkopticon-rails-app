class AddIpToReputationStatements < ActiveRecord::Migration
  def self.up
    add_column :reputation_statements, :ip, :string
  end

  def self.down
    remove_column :reputation_statements, :ip
  end
end
