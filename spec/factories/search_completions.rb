# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :search_completion do
    search_term "MyString"
    search_count 1
  end
end
