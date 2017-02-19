class ChangeCommentingColumnsOnPeople < ActiveRecord::Migration[5.0]
  def change
    change_column :people, :can_comment, :boolean, null: false, default: true
    remove_columns :people,
                   :commenting_requested,
                   :commenting_requested_at,
                   :commenting_request_ignored,
                   :commenting_enabled_by,
                   :commenting_enabled_at,
                   :commenting_disabled_by,
                   :commenting_disabled_at
  end
end
