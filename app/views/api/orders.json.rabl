collection @object, :root => nil, :object_root => false
attributes :id, :amount, :created_at
child :user do
  attributes :id, :username
  node :full_name do |u|
    u.contact ? u.contact.full_name : ''
  end
end
child :shop_product do
  attributes :id
  node :name do |u|
    u.product.name
  end
end