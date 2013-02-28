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
  node :bid_count do |ap|
    ap.promotion_bidders.sum(:amount)
  end
end