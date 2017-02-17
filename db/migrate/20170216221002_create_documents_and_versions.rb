class CreateDocumentsAndVersions < ActiveRecord::Migration[5.0]
  def change
    create_table :docs_documents do |t|
      t.string :name, limit: 20
      t.string :title, limit: 100
      t.text :body

      t.timestamps
    end
    create_table :docs_versions do |t|
      t.string :name, limit: 20
      t.string :title, limit: 100
      t.text :body
      t.references :document, foreign_key: { to_table: :docs_documents }, index: true

      t.timestamps
    end
  end
end
