class ChangeShopLocationFromGeometryToGeography < ActiveRecord::Migration
  def up
    remove_column :shops, :location
    change_table :shops do |t|
      t.point :location, :geographic => true
    end
  end

  def down
    remove_column :shops, :location
    change_table :shops do |t|
      t.point :location
    end
  end
end
