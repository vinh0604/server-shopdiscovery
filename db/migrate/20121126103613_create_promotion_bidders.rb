class CreatePromotionBidders < ActiveRecord::Migration
  def change
    create_table :promotion_bidders do |t|
      t.references :user
      t.references :promotion
      t.integer :amount

      t.timestamps
    end
  end
end
