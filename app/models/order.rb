class Order < ActiveRecord::Base
  belongs_to :shop_product
  belongs_to :user
  has_one :order_shipment, :dependent => :destroy
  has_one :purchased_order, :dependent => :nullify

  validates :amount, :price , :numericality => { :greater_than => 0 }

  STATUSES = {
    :new => 1,
    :waited => 2,
    :confirmed => 3,
    :finished => 4,
    :canceled => 5
  }.freeze
end
