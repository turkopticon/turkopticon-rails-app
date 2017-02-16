class RemoveMostRecentFirstOrderReviewsFancyLinksFromPeople < ActiveRecord::Migration[5.0]
  def change
    remove_column :people, :most_recent_first_in_my_reviews
    remove_column :people, :order_reviews_by_edit_date
    remove_column :people, :show_fancy_links
  end
end
