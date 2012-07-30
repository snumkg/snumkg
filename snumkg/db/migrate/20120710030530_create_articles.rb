class CreateArticles < ActiveRecord::Migration
  def change
    create_table :articles do |t|
      t.integer :user_id
      t.integer :board_id
      t.string  :title
      t.text    :body
      t.integer :view_count, :default => 0
      t.string  :date
      t.integer :article_type, :default => 0 
      # article_type 0: 일반게시물, 1: 소꼬지게시물

      t.timestamps
    end
  end
end
