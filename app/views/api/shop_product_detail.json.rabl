collection @object, :object_root => false
attributes :id, :price, :status, :warranty, :origin, :description
child :photos do
  attributes :id
  node :url do |p|
    p.image.url
  end
end