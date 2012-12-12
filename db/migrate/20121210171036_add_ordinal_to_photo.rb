class AddOrdinalToPhoto < ActiveRecord::Migration
  def up
    add_column :photos, :ordinal, :integer
  end
  def down
    remove_column :photos, :ordinal
  end
end
