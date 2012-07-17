class CreateLikeArticles < ActiveRecord::Migration
  def change
    create_table :like_articles do |t|
      t.integer :user_id
      t.integer :article_id

      t.timestamps
    end
  end
end
