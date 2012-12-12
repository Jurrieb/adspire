class CreateLeads < ActiveRecord::Migration
  def change
    create_table :leads do |t|
      t.integer :click_id
      t.integer :user_id
      t.integer :product_id
      t.integer :status

      t.timestamps
    end
  end
end
