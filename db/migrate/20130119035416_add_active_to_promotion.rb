class AddActiveToPromotion < ActiveRecord::Migration
  def up
    add_column :promotions, :active, :boolean
  end

  def down
    remove_column :promotions, :active
  end
end
