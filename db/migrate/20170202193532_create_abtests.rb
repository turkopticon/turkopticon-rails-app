class CreateAbtests < ActiveRecord::Migration[5.0]
  def change
    enable_extension 'btree_gin'

    create_table :ab_tests do |t|
      t.string :name, index: { using: :gin }

      t.timestamps
    end

    create_table :ab_variants do |t|
      t.string :name, index: { using: :gin }
      t.jsonb :data, null: false, default: { sample: 0, distribution: {}, conversions: { total: 0, unique: 0 } }
      t.references :test, foreign_key: { to_table: :ab_tests }, index: true

      t.timestamps
    end
  end
end
