class CreateNotifications < ActiveRecord::Migration
  def change
    create_table :notifications do |t|
      t.integer :user_id
      t.string :message
      t.string :url
      t.boolean :deleted
      t.timestamps
    end
  end
end
