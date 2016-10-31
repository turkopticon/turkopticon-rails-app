class CreateHits < ActiveRecord::Migration[5.0]
  def change
    create_table :hits do |t|
      t.string :title, index: true
      t.decimal :reward, precision: 6, scale: 2
      t.references :requester, foreign_key: true, index: true

      t.timestamps
    end
  end
end
