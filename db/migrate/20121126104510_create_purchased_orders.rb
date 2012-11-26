class CreatePurchasedOrders < ActiveRecord::Migration
  def change
    create_table :purchased_orders do |t|
      t.references :order
      t.references :contact
      t.string :po_number
      t.integer :status

      t.timestamps
    end
  end
end
