class AddShopKeyToShop < ActiveRecord::Migration
  def up
    add_column :shops, :shop_key, :string
  end

  def down
    remove_column :shops, :shop_key
  end
end
