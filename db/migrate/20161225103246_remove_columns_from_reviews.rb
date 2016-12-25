class RemoveColumnsFromReviews < ActiveRecord::Migration[5.0]
  def change
    change_table(:reviews) { |t| t.remove :deceptive, :deceptive_context, :completed, :pending }
  end
end
