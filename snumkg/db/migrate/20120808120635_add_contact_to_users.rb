class AddContactToUsers < ActiveRecord::Migration
  def change
    add_column :users, :contact, :boolean, :default => false
  end
end
