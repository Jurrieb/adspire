class AddColumnsToProduct < ActiveRecord::Migration
  def change
  	  add_column :products, :url, :string
  	  add_column :products, :description, :string
  	  add_column :products, :image, :string
  	  add_column :products, :price, :decimal
  end
end