class RenameFlagToLegacyFlag < ActiveRecord::Migration[5.0]
  def change
    rename_table :flags, :legacy_flags
  end
end
