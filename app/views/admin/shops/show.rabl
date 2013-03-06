object @shop
attributes :id, :name, :street_address, :city, :district, :location, :website, :phones, :description
child :managers do
  attributes :owner
  child :user do
    attributes :id, :username, :email
    child :contact do
      attributes :full_name
    end
  end
end