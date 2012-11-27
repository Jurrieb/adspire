class RenameTableFilterOptions < ActiveRecord::Migration
  def change
    rename_table :filter_options, :filteroptions
  end
end
