class CreateShopProducts < ActiveRecord::Migration
  def change
    create_table :shop_products do |t|
      t.references :product
      t.references :shop
      t.integer :status
      t.decimal :price
      t.integer :warranty
      t.integer :origin
      t.integer :avaibility
      t.text :description
      t.float :avg_score
      t.integer :review_count

      t.timestamps
    end
  end
end
