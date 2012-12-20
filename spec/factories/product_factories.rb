FactoryGirl.define do
  factory :product do
    name "Product"
    specifics({"Manufacturer"=> "Ruby"})
    barcode "12345678901234"
  end
end