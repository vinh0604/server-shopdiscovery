class WishList < ActiveRecord::Base
  belongs_to :user
  belongs_to :shop_product
end
