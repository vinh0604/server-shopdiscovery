collection @object, :root => 'shops'
attributes :id, :name, :avg_score, :review_count, :full_address
child :thumb do
  node :url do |p|
    p.image.thumb.url
  end
end
child :tags do
  attributes :value
end
node :is_owner do |s|
  s.respond_to?(:is_owner) ? s.is_owner : false
end