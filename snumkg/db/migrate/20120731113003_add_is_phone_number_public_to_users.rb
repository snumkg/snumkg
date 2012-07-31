class AddIsPhoneNumberPublicToUsers < ActiveRecord::Migration
  def change
    add_column :users, :is_phone_number_public, :boolean, :default => true
  end
end
