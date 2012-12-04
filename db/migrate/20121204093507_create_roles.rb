class CreateRoles < ActiveRecord::Migration
  def change
    create_table :roles do |t|
      t.string :name
      t.timestamps
  	end
  	 create_table :users_roles, :id => false do |t|
      t.belongs_to :user
      t.belongs_to :role
    end
  end
end
