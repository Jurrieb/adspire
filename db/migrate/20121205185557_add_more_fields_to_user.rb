class AddMoreFieldsToUser < ActiveRecord::Migration
  def change
	change_table :users do |t|
		t.string 	:street
		t.integer	:housenumber
		t.string 	:zip
		t.string 	:place
		t.string 	:btw
		t.string 	:kvk
	end
  end
end
