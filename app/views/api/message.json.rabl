collection @object
attributes :unread?
glue :message do
  attributes :id, :title, :headline, :sent_date
  child :sender do
    attributes :id, :username
    node :full_name do |u|
      u.contact.full_name
    end
  end
end