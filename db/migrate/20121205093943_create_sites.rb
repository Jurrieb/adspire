class CreateSites < ActiveRecord::Migration
  def change
	create_table :sites do |w|
		w.integer	:user_id
		w.integer	:name
		w.text   	:url
		w.text   	:description
		w.integer	:category_id
		w.boolean	:active
		w.integer	:status
		w.timestamps
	end
  end
end