class OrderShipment < ActiveRecord::Base
  belongs_to :order
  belongs_to :contact

  TYPES = {
    :shop => 1,
    :home => 2
  }.freeze
end
