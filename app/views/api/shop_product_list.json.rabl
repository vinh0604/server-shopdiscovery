collection @object
attributes :id, :price, :warranty, :origin
attribute :status => :condition
child :thumb do
  node :url do |t|
    t.image.url
  end
end
child :shop do 
  attributes :id, :name
end
child :product do 
  attributes :id, :name, :barcode
  child :category do
    attributes :id, :name
  end
end