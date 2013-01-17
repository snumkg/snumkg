#encoding: utf-8
class CreateArticles < ActiveRecord::Migration
  def change
    create_table :articles do |t|
      t.integer :user_id
      t.integer :board_id
      t.string  :title
      t.text    :body
			t.integer :number #글번호

      t.integer :view_count, :default => 0
      t.boolean :is_notice, :default => false #공지글인지
      t.string :article_type

      t.datetime  :date #소꼬지용

      #익게용
      t.string :anonymous_name
      t.string :password_salt
      t.string :password_hash 

      t.timestamps
    end
  end
end
