class AddTsvectorToProduct < ActiveRecord::Migration
  def up
    add_column :products, :textsearchable, :tsvector
  end

  def down
    remove_column :products, :textsearchable
  end
end
