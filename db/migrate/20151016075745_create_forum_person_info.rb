class CreateForumPersonInfo < ActiveRecord::Migration
  def self.up
    create_table :forum_person_info do |t|
      t.integer :person_id
      t.decimal :karma, :precision => 3, :scale => 2
      t.string :mail_forum_notifications
      t.timestamps
    end
  end

  def self.down
    drop_table :forum_person_info
  end
end