class CreateRequestersv2 < ActiveRecord::Migration[5.0]
  def change
    create_table :requesters do |t|
      t.string :rname, index: true
      t.string :rid, index: true
      t.text :aliases

      t.timestamps
    end
  end
end
