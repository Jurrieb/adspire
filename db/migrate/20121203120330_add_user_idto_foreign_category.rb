class AddUserIdtoForeignCategory < ActiveRecord::Migration
  def change
  	add_column :foreign_categories, :user_id, :integer
  end
end
