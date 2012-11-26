class CreateMessageReceivers < ActiveRecord::Migration
  def change
    create_table :message_receivers do |t|
      t.references :user
      t.references :message

      t.timestamps
    end
  end
end
