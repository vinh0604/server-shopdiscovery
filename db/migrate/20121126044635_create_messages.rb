class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.integer :sender_id
      t.string :title
      t.text :content
      t.datetime :sent_date

      t.timestamps
    end
  end
end
