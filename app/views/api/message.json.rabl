collection @object, :root => 'messages', :object_root => 'message'
attributes :unread?
glue :message do
  attributes :id, :title, :headline, :sent_date
  child :user do
    attributes :id, :username
    node :full_name do |u|
      u.contact.full_name
    end
  end
end