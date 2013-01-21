collection @object
attributes :id, :price
child :thumb do
  node :url do |t|
    t.image.thumb.url
  end
end
child :product do 
  attributes :id, :name
end
child :active_promotion do 
  attributes :id, :price, :expires, :amount
end