class CreateNewsfeeds < ActiveRecord::Migration
  def change
    create_table :newsfeeds do |t|
      t.integer :comment_id
      t.integer :article_id

      t.timestamps
    end
  end
end
