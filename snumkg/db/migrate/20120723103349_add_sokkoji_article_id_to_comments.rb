class AddSokkojiArticleIdToComments < ActiveRecord::Migration
  def change
    add_column :comments, :sokkoji_article_id, :integer
  end
end
