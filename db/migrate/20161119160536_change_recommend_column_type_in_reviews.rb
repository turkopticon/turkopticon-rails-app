class ChangeRecommendColumnTypeInReviews < ActiveRecord::Migration[5.0]
  def change
    change_column :reviews, :recommend, :string
  end
end
