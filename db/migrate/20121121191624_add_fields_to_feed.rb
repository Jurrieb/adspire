class AddFieldsToFeed < ActiveRecord::Migration
  def change
  	  add_column :feeds, :xml_path, :string
  	  add_column :feeds, :feed_path, :string
  end
end
