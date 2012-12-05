class AddColumnToField < ActiveRecord::Migration
  def change
  	add_column :fields, :product_column_name, :string
  end
end
