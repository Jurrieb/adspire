class AddColumnsTofeeds < ActiveRecord::Migration
  def change
  	add_column :feeds, :interval_in_seconds, :integer
  	add_column :feeds, :last_parse, :datetime
  end
end
