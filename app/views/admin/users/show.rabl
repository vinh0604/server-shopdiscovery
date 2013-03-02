object @user

attributes :id, :username, :email, :avatar
child :contact do
  attributes :id, :full_name, :first_name, :last_name, :phone, :address, :identity, :gender, :birthdate
end