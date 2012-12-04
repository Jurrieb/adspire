class RedefineDatafeedkeys < ActiveRecord::Migration
   def change
  	add_column :datafeed_keys, :feed_id, :integer
  	rename_column :datafeed_keys, :foreign_key_name, :name
  end
end
