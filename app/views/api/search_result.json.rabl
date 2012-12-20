collection @object
attributes :id, :price, :status, :avg_score, :review_count
child :thumb do
  node :url do |t|
    t.image.url
  end
end
child :shop do 
  attributes :id, :name, :distance
end
child :product do 
  attributes :id, :name
  child :category do
    attributes :id, :name
  end
end