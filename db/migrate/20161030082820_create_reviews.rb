class CreateReviews < ActiveRecord::Migration[5.0]
  def change
    create_table :reviews do |t|
      t.boolean :tos
      t.text :tos_context
      t.boolean :broken
      t.text :broken_context
      t.boolean :deceptive
      t.text :deceptive_context
      t.decimal :reward, precision: 6, scale: 2
      t.string :completed
      t.integer :time
      t.string :comm
      t.string :pending
      t.integer :time_pending
      t.string :rejected
      t.boolean :recommend
      t.text :recommend_context
      t.text :context
      t.references :hit, foreign_key: true, index: true
      t.references :person, foreign_key: true, index: true

      t.timestamps
    end
  end
end
