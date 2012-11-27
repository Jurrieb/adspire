class CreateDatafeedKeys < ActiveRecord::Migration
  def change
    create_table :datafeed_keys do |t|
      t.string :key_name
      t.string :foreign_key_name

      t.timestamps
    end
  end
end
