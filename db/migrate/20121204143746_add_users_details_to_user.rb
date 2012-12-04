class AddUsersDetailsToUser < ActiveRecord::Migration
  def change

	change_table :users do |t|
		t.string 	:name
		t.string 	:lastname
		t.string 	:phone
		t.string 	:country
		t.string 	:organisation
		t.text   	:url
		t.integer	:category_id
		t.text   	:website
		t.text   	:comment
	end
  end
end