class Order < ActiveRecord::Base
  belongs_to :shop_product
  belongs_to :user
  has_one :order_shipment, :dependent => :destroy
  has_one :purchased_order, :dependent => :nullify
  has_many :promotion_bidders, :dependent => :delete_all

  after_save :send_order_notification, :delete_promotion_bidders

  validates :amount, :price , :numericality => { :greater_than => 0 }

  STATUSES = {
    :new => 1,
    :waited => 2,
    :confirmed => 3,
    :finished => 4,
    :canceled => 5
  }.freeze

  private
  def send_order_notification
    if status_changed? and status_was == STATUSES[:new] and (status == STATUSES[:confirmed] or status == STATUSES[:canceled])
      _is_confirmed = (status == STATUSES[:confirmed])
      _action = _is_confirmed ? 'confirmed' : 'canceled'
      notif_content = "[[Shop:#{self.shop_product.shop_id}]] has #{_action} your order for [[Product:#{self.shop_product.product_id}]]"
      notif_type = _is_confirmed ? Notification::TYPES[:order_confirm] : Notification::TYPES[:order_cancel]
      notification = Notification.create({
        :notification_type => notif_type,
        :content => notif_content,
        :user_id => self.user_id,
        :source => self,
        :status => Notification::STATUSES[:new]
      })
    end
  end

  def delete_promotion_bidders
    if status == STATUSES[:canceled]
      PromotionBidder.where(:order_id => self.id).delete_all
    end
  end
end
