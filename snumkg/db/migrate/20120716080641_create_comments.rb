class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.integer :article_id
      t.integer :user_id
      t.integer :profile_user_id # 프로필에 댓글 달 때
      t.string :content
      #t.string :comment_type
      t.string :username
      t.string :password_salt
      t.string :password_hash
      # comment_type 0: 게시물 댓글, 1: 프로필 댓글
      

      t.timestamps
    end
  end
end
