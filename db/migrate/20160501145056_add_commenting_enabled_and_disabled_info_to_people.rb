class AddCommentingEnabledAndDisabledInfoToPeople < ActiveRecord::Migration
  def self.up
    add_column :people, :commenting_enabled_by, :integer
    add_column :people, :commenting_enabled_at, :datetime
    add_column :people, :commenting_disabled_by, :integer
    add_column :people, :commenting_disabled_at, :datetime
  end

  def self.down
    remove_column :people, :commenting_enabled_by
    remove_column :people, :commenting_enabled_at
    remove_column :people, :commenting_disabled_by
    remove_column :people, :commenting_disabled_at
  end
end
