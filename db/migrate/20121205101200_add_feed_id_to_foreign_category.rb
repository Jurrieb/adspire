class AddFeedIdToForeignCategory < ActiveRecord::Migration
  def change
  	add_column :foreign_categories, :feed_id, :integer
  end
end
