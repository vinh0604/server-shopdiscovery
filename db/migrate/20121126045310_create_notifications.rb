class CreateNotifications < ActiveRecord::Migration
  def change
    create_table :notifications do |t|
      t.references :user
      t.string :source_type
      t.integer :source_id
      t.integer :type
      t.text :content

      t.timestamps
    end
  end
end
