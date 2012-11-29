class AddStatusToFeed < ActiveRecord::Migration
  def change
  	add_column :feeds, :status, :string
  	add_column :feeds, :user_id, :integer
  end
end
