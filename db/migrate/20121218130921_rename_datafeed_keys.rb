class RenameDatafeedKeys < ActiveRecord::Migration
  def change
  	rename_table :datafeed_keys, :feednodes
  end
end
