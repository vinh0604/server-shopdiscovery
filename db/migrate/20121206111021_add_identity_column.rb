class AddIdentityColumn < ActiveRecord::Migration
  def up
    change_table :users do |t|
      t.string :identity
    end
  end

  def down
    remove_column :users, :identity
  end
end
