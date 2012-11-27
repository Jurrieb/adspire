class DataFeedKeysAddFieldId < ActiveRecord::Migration
  def change
 		remove_column :datafeed_keys, :key_name
  	  add_column :datafeed_keys, :field_id, :integer
  end
end
