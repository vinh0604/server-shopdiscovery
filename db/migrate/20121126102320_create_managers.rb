class CreateManagers < ActiveRecord::Migration
  def change
    create_table :managers do |t|
      t.references :user
      t.boolean :owner

      t.timestamps
    end
  end
end
