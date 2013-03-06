class Manager < ActiveRecord::Base
  belongs_to :shop
  belongs_to :user

  def self.update_shop_managers(shop, managers_data)
    self.where(:shop_id => shop.id).delete_all
    managers = []
    managers_data.each do |data|
      next if data[:id].blank?
      manager = Manager.create(:shop_id => shop.id, :user_id => data[:id], :owner => data[:owner])
      managers << manager
    end
    managers
  end
end
