class RemoveTypeColumnInFilteroptions < ActiveRecord::Migration
  def change
 	remove_column :filteroptions, :type
  	add_column :datafeed_keys, :name, :string
  end
end
