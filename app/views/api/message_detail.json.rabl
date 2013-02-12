collection @object
attributes :id, :title, :content, :sent_date
child :sender do
  attributes :id, :username
  node :full_name do |u|
    u.contact.full_name
  end
end
child :message_receivers => :receivers do
  attributes :id, :user_id
  node :username do |r|
    r.user.username
  end
end