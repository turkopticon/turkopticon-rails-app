class AddConfirmationTokenToPerson < ActiveRecord::Migration[5.0]
  def change
    add_column :people, :confirmation_token, :string
    add_index :people, :confirmation_token
  end
end
