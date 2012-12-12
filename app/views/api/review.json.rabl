collection @object, :object_root => nil
attributes :id, :title, :content, :rating, :updated_at
child :reviewer do
  attributes :id
  node :full_name do |r|
    r.contact ? r.contact.full_name : ''
  end
end