class AddShopToManager < ActiveRecord::Migration
  def up
    add_column :managers, :shop_id, :integer
  end

  def down
    remove_column :managers, :shop_id
  end
end
