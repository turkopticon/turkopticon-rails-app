class CreateReports < ActiveRecord::Migration
  def self.up
    create_table :reports do |t|
      t.integer :person_id
      t.integer :requester_id
      t.string :hit_id
      t.text :description

      t.timestamps
    end
  end

  def self.down
    drop_table :reports
  end
end
