class ChangeTypeFeed < ActiveRecord::Migration
  def change
	remove_column :feeds, :type
	add_column :feeds, :method_type, :string
  end
end
