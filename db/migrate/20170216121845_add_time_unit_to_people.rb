class AddTimeUnitToPeople < ActiveRecord::Migration[5.0]
  def change
    add_column :people, :time_unit, :string, limit: 3, default: 'hr'
  end
end
