class PromotionBidder < ActiveRecord::Base
  belongs_to :promotion
  belongs_to :user
  belongs_to :order
end
