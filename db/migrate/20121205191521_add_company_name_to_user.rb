class AddCompanyNameToUser < ActiveRecord::Migration
  def change
	change_table :users do |t|
		t.string :company_name
	end
  end
end
