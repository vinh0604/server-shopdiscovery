class Promotion < ActiveRecord::Base
  belongs_to :shop_product
  after_save :send_notification

  private
  def send_notification
    if self.active and (self.expires >= DateTime.now) and (self.id_changed? or self.active_changed? or (self.expires_was < DateTime.now))
      shop = self.shop_product.shop
      notif_user_ids = shop_product.wish_lists.map { |w| w.user_id } |
                          shop.favorite_shops.map { |w| w.user_id }
      notif_content = "There is a new promotion for [[Product:#{shop_product.product_id}]] at [[Shop:#{shop.id}]]"
      notif_user_ids.each do |_id|
        notification = Notification.create({
          :notification_type => Notification::TYPES[:promotion],
          :content => notif_content,
          :user_id => _id,
          :source => shop_product,
          :status => Notification::STATUSES[:new]
        })
      end
    end
  end
end
