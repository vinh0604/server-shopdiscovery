object :object_root => nil
attributes :id, :price, :warranty, :origin, :description, 
           :avg_score, :review_count, :status
child :photos do
  attributes :id
  node :url do |p|
    p.image.url
  end
end
child :shop do 
  attributes :id, :name
end
child :product do 
  attributes :id, :name, :barcode, :specifics
  child :category do
    attributes :id, :name
    node :ancestors do |sp|
      sp.ancestors
    end
  end
end
child :active_promotion do 
  attributes :id, :price, :expires, :active, :amount
end
