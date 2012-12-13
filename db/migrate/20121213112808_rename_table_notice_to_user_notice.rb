class RenameTableNoticeToUserNotice < ActiveRecord::Migration
  def change
	rename_table :notices, :usernotices
  end
end
