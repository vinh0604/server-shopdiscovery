collection @object, :object_root => nil
attributes :id, :name, :avg_score, :review_count, :full_address
child :thumb do
  node :url do |p|
    p.image.url
  end
end
child :tags do
  attributes :value
end