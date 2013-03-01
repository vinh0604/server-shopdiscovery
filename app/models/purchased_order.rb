class PurchasedOrder < ActiveRecord::Base
  belongs_to :order
  belongs_to :contact

  STATUSES = {
    :fail => 0,
    :success => 1
  }.freeze
end
