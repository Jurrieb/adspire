class CreateControllers < ActiveRecord::Migration
  def change
    create_table :controllers do |t|
      t.string :statistics

      t.timestamps
    end
  end
end
