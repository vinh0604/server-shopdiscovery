class Tag < ActiveRecord::Base
  has_and_belongs_to_many :shops
  has_and_belongs_to_many :products
  has_and_belongs_to_many :users
end
