class ShopProduct < ActiveRecord::Base
  belongs_to :shop
  belongs_to :product
  has_many :photos, :as => :imageable
  has_many :reviews, :as => :reviewable
  has_one :thumb, :class_name => 'Photo', :as => :imageable,
          :conditions => {:ordinal => 1}
end
