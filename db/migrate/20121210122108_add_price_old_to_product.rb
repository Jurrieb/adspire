class AddPriceOldToProduct < ActiveRecord::Migration
  def change
    add_column :products, :price_old, :decimal
  end
end
