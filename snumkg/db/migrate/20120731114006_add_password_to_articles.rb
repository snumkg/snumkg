class AddPasswordToArticles < ActiveRecord::Migration
  def change
    add_column :articles, :password_salt, :string
    add_column :articles, :password_hash, :string
  end
end
