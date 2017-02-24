class RenameRnameToNameOnRequesters < ActiveRecord::Migration[5.0]
  def change
    rename_column :requesters, :rname, :name
  end
end
