class ChangeIntegerIntoStringInSites < ActiveRecord::Migration
  def change
	remove_column :sites, :name
	add_column :sites, :name, :string
  end
end
