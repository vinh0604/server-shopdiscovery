object :object_root => nil
attributes :id, :amount, :price, :total, :status, :created_at
child :user do
  attributes :id, :username
end
child :order_shipment => :shipment do
  attributes :id, :fee, :ship_date, :ship_type
  child :contact do
    attributes :full_name, :identity, :phone, :address, :gender
  end
end
child :shop_product do
  attributes :id
  node :name do |u|
    u.product.name
  end
end