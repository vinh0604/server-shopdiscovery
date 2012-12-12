class Product < ActiveRecord::Base
  belongs_to :category
  has_many :shop_products

  serialize :specifics, ActiveRecord::Coders::Hstore
end
