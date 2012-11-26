class CreateJoinTables < ActiveRecord::Migration
  def up
    create_table :tags_users do |t|
      t.references :tag
      t.references :user
    end

    create_table :shops_tags do |t|
      t.references :tag
      t.references :shop
    end

    create_table :products_tags do |t|
      t.references :tag
      t.references :product
    end
  end

  def down
    drop_table :tags_users
    drop_table :shops_tags
    drop_table :products_tags
  end
end
