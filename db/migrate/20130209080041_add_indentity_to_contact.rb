class AddIndentityToContact < ActiveRecord::Migration
  def up
    add_column :contacts, :identity, :string
  end

  def down
    remove_column :contacts, :identity
  end
end
