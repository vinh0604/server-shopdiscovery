class CreatePromotions < ActiveRecord::Migration
  def change
    create_table :promotions do |t|
      t.references :shop_product
      t.decimal :price
      t.datetime :expires
      t.datetime :active_date
      t.integer :amount

      t.timestamps
    end
  end
end
