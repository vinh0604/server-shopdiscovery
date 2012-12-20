collection @object, :object_root => nil
attributes :id, :name
child :category do
  attributes :id, :name
end
node :shop_count do |p|
  p.shop_count
end
node :min_price do |p|
  p.min_price
end
node :photo do |p|
  p.thumb ? p.thumb.image.url : ''
end