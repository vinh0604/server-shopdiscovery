class PurchasedOrder < ActiveRecord::Base
  belongs_to :order
  belongs_to :contact

  STATUSES = {
    
  }.freeze
end
