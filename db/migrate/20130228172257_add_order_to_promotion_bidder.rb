class AddOrderToPromotionBidder < ActiveRecord::Migration
  def up
    add_column :promotion_bidders, :order_id, :integer
  end

  def down
    remove_column :promotion_bidders, :order_id
  end
end
