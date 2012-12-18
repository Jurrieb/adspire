class CreateCategories < ActiveRecord::Migration
  def change
  	create_table "categories", :force => true do |t|
    	t.string   "name"
    	t.datetime "created_at", :null => false
    	t.datetime "updated_at", :null => false
	end
  end
end