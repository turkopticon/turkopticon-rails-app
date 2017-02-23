class AddPasswordResetTokenToPeople < ActiveRecord::Migration[5.0]
  def change
    add_column :people, :password_reset_token, :string, limit: 55
    add_column :people, :password_reset_expiration, :datetime
    add_index :people, :password_reset_token
  end
end
