class AddIpToReports < ActiveRecord::Migration
  def self.up
    add_column :reports, :ip, :string
  end

  def self.down
    remove_column :reports, :ip
  end
end
