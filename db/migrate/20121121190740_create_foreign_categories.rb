class CreateForeignCategories < ActiveRecord::Migration
  def change
    create_table :foreign_categories do |t|
      t.integer :category_id
      t.string :name

      t.timestamps
    end
  end
end
