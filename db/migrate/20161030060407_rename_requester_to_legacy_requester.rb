class RenameRequesterToLegacyRequester < ActiveRecord::Migration[5.0]
  def change
    rename_table :requesters, :legacy_requesters
  end
end
