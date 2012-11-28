class RemoveTypeColumnInFilteroptions < ActiveRecord::Migration
  def change
 	remove_column :filteroptions, :type
  	add_column :filteroptions, :name, :string
  end
end
