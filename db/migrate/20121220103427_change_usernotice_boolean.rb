class ChangeUsernoticeBoolean < ActiveRecord::Migration
  def change
    change_table :Usernotices do |t|
      t.change :lead, :boolean, :default => false, :null => false
      t.change :sale, :boolean, :default => false, :null => false
      t.change :feed, :boolean, :default => false, :null => false
      t.change :result, :boolean, :default => false, :null => false
      t.change :status, :boolean, :default => false, :null => false
      t.change :merchant, :boolean, :default => false, :null => false
      t.change :action, :boolean, :default => false, :null => false
    end
  end
end
