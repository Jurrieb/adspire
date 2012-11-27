class CreateFilterOptions < ActiveRecord::Migration
  def change
    create_table :filter_options do |t|
      t.integer :filter_id
      t.string :type
      t.string :value

      t.timestamps
    end
  end
end
