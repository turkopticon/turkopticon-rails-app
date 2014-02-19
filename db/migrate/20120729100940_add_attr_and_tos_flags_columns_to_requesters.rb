class AddAttrAndTosFlagsColumnsToRequesters < ActiveRecord::Migration
  def self.up
    add_column :requesters, :av_comm, :decimal, :precision => 3, :scale => 2
    add_column :requesters, :av_pay, :decimal, :precision => 3, :scale => 2
    add_column :requesters, :av_fair, :decimal, :precision => 3, :scale => 2
    add_column :requesters, :av_fast, :decimal, :precision => 3, :scale => 2
    add_column :requesters, :tos_flags, :integer
  end

  def self.down
    remove_column :requesters, :av_comm
    remove_column :requesters, :av_pay
    remove_column :requesters, :av_fair
    remove_column :requesters, :av_fast
    remove_column :requesters, :tos_flags
  end
end
