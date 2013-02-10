class AddStatusToNotification < ActiveRecord::Migration
  def up
    add_column :notifications, :status, :integer, :default => 0
  end

  def down
    remove_column :notifications, :status
  end
end
