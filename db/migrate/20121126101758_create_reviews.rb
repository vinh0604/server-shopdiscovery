class CreateReviews < ActiveRecord::Migration
  def change
    create_table :reviews do |t|
      t.integer :reviewer_id
      t.string :title
      t.text :content
      t.integer :rating
      t.references :reviewable, :polymorphic => true

      t.timestamps
    end
  end
end
