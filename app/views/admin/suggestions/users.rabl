collection @users, :root => false, :object_root => false
attributes :id, :username, :email
child :contact do
  attributes :full_name
end 