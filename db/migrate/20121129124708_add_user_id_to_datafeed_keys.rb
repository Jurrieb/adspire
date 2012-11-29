class AddUserIdToDatafeedKeys < ActiveRecord::Migration
  def change
  	add_column :datafeed_keys, :user_id, :integer
  end
end
