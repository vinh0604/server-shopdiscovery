class CreateProducts < ActiveRecord::Migration
  def change
    create_table :products do |t|
      t.references :category
      t.string :name
      t.string :barcode
      t.hstore :specifics

      t.timestamps
    end
  end
end
