class CreateClicks < ActiveRecord::Migration
  def change
    create_table :clicks do |t|
      t.integer :user_id
      t.integer :product_id
      t.string :referer
      t.string :ip_client

      t.timestamps
    end
  end
end
