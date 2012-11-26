class CreateOrderShipments < ActiveRecord::Migration
  def change
    create_table :order_shipments do |t|
      t.references :order
      t.references :contact
      t.datetime :ship_date
      t.decimal :fee
      t.integer :ship_type

      t.timestamps
    end
  end
end
