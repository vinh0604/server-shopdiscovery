object :object_root => nil
attributes :id, :name, :location, :avg_score, :review_count, 
           :website, :phones, :description, :full_address,
           :street_address, :district, :city
child :photos do
  attributes :id
  node :url do |p|
    p.image.url
  end
end
child :tags do
  attributes :value
end
node :is_owner do |s|
  s.respond_to?(:is_owner) ? s.is_owner : false
end