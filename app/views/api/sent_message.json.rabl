collection @object
attributes :id, :title, :headline, :sent_date
child :message_receivers => :receivers do
  attributes :id, :user_id
  node :username do |r|
    r.user.username
  end
end