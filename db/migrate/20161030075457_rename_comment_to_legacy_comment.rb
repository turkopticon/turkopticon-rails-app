class RenameCommentToLegacyComment < ActiveRecord::Migration[5.0]
  def change
    rename_table :comments, :legacy_comments
  end
end
