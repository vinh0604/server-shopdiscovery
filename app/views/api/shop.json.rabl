object :object_root => nil
attributes :id, :name, :location, :avg_score, :review_count, 
           :website, :phones, :description, :full_address
child :creator do
  attributes :id, :username
end
child :photos do
  node :url do |p|
    p.image.url
  end
end
child :tags do
  attributes :value
end