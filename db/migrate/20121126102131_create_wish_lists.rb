class CreateWishLists < ActiveRecord::Migration
  def change
    create_table :wish_lists do |t|
      t.references :shop_product
      t.references :user

      t.timestamps
    end
  end
end
