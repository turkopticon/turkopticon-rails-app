class CreateCommentsv2 < ActiveRecord::Migration[5.0]
  def change
    create_table :comments do |t|
      t.text :body
      t.references :review, foreign_key: true, index: true
      t.references :person, foreign_key: true, index: true

      t.timestamps
    end
  end
end
