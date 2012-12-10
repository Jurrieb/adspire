class DeleteUserIdFromFilter < ActiveRecord::Migration
  def change
    remove_column :filters, :user_id
  end
end
