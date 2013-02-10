class AddStatusToMessageReceiver < ActiveRecord::Migration
  def up
    add_column :message_receivers, :status, :integer, :default => 0
    add_column :messages, :status, :integer, :default => 0
  end

  def down
    remove_column :message_receivers, :status
    remove_column :messages, :status
  end
end
