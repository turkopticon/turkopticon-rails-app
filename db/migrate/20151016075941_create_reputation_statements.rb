class CreateReputationStatements < ActiveRecord::Migration
  def self.up
    create_table :reputation_statements do |t|
      t.integer :person_id
      t.integer :post_id
      t.string :statement
      t.decimal :effect, :precision => 3, :scale => 2
      t.timestamps
    end
  end

  def self.down
    drop_table :reputation_statements
  end
end