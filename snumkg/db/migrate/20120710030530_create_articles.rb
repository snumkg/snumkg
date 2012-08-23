#encoding: utf-8
class CreateArticles < ActiveRecord::Migration
  def change
    create_table :articles do |t|
      t.integer :user_id
      t.integer :board_id
      t.string  :title
      t.text    :body
      t.integer :view_count, :default => 0
      t.datetime  :date
      t.string :article_type, :default => "일반"

      t.timestamps
    end
  end
end
