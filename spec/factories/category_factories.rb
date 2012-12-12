FactoryGirl.define do
  factory :category do
    name "Cellphone"
  end
  factory :sub_category, :class => Category do
    name "Smartphone"
    association :parent, :factory => :category
  end
end