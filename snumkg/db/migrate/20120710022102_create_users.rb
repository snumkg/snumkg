class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
			t.string :username
			t.string :password_hash
			t.string :password_salt
			t.string :nickname
			t.string :phone_number  #폰번호
			t.string :department    #학과
			t.string :entrance_year #학번 (09, .. )
			t.string :email
      t.date :birthday
      t.integer :alarm_counts, default: 0
      t.integer :level, default: 1
      t.string  :profile_image_path
      t.string  :thumbnail_image_path
      t.boolean :admin, :default => false
      t.boolean :is_phone_number_public, :default => true


      t.timestamps
    end
  end
end
