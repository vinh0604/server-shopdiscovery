class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.references :user
      t.references :shop_product
      t.decimal :price
      t.integer :amount
      t.decimal :tax
      t.decimal :total
      t.integer :status

      t.timestamps
    end
  end
end
