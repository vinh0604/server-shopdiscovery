class CreateContacts < ActiveRecord::Migration
  def change
    create_table :contacts do |t|
      t.string :first_name
      t.string :last_name
      t.integer :gender
      t.datetime :birthdate
      t.string :phone
      t.string :address

      t.timestamps
    end
  end
end
