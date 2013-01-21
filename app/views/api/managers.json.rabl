collection @object, :object_root => false
attributes :id, :owner
child :user do
  attributes :id, :username
  node :avatar do |u|
    u.avatar.url
  end
  node :full_name do |u|
    u.contact ? u.contact.full_name : ''
  end
end