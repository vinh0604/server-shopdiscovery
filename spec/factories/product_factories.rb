FactoryGirl.define do
  factory :product do
    name "Product"
    specifics({"Manufacturer"=> "Ruby"})
  end
end