class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
			t.string :username
			t.string :password_hash
			t.string :password_salt
			t.string :nickname
			t.string :phone_number
			t.string :department
			t.integer :grade
			t.string :email

      t.timestamps
    end
  end
end
