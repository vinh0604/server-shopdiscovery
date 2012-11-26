class CreateFavoriteShops < ActiveRecord::Migration
  def change
    create_table :favorite_shops do |t|
      t.references :shop
      t.references :user

      t.timestamps
    end
  end
end
