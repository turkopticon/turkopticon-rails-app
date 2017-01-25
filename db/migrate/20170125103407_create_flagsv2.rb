class CreateFlagsv2 < ActiveRecord::Migration[5.0]
  def change
    create_table :flags do |t|
      t.string :reason
      t.text :context
      t.references :person, foreign_key: true, index: true
      t.references :review, foreign_key: true, index: true

      t.timestamps
    end
  end
end
