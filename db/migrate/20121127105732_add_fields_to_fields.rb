class AddFieldsToFields < ActiveRecord::Migration
   def change
  	  add_column :fields, :visible, :boolean
  end
end
