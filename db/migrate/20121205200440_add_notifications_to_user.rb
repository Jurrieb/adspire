class AddNotificationsToUser < ActiveRecord::Migration
  def change
	change_table :users do |t|
		t.boolean :notification_lead
		t.boolean :notification_sale
		t.boolean :notification_feed
		t.boolean :notification_result
		t.boolean :notification_status
		t.boolean :notification_merchant
	end
  end
end
