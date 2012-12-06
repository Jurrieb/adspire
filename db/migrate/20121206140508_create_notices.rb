class CreateNotices < ActiveRecord::Migration
  def change
    create_table :notices do |t|
		t.boolean :lead
		t.boolean :sale
		t.boolean :feed
		t.boolean :result
		t.boolean :status
		t.boolean :merchant
		t.boolean :action
		t.timestamps

		t.belongs_to :user
    end
  end
end
