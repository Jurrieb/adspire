class AddColumnToProduct < ActiveRecord::Migration
  def change
  	add_column :products, :unique_hash, :integer
  	add_column :products, :status, :integer
  end
end
