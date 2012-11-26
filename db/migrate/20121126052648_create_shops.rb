class CreateShops < ActiveRecord::Migration
  def change
    create_table :shops do |t|
      t.string :name
      t.string :website
      t.text :phones
      t.string :street_address
      t.string :district
      t.string :city
      t.point :location
      t.float :avg_score
      t.integer :review_count
      t.text :description
      t.integer :creator_id

      t.timestamps
    end
  end
end
