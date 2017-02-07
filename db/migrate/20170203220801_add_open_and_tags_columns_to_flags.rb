class AddOpenAndTagsColumnsToFlags < ActiveRecord::Migration[5.0]
  def change
    add_column :flags, :open, :boolean, null: false, default: true
    add_column :flags, :tags, :string, array: true, null: false, length: 50, default: '{}'
    add_column :flags, :activity, :jsonb, null: false, default: []

    add_index :flags, :tags, using: :gin
  end
end
