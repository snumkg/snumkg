class AddNoticeToArticles < ActiveRecord::Migration
  def change
    add_column :articles, :notice, :boolean, :default => false
  end
end
