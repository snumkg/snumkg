class CreateSokkojiArticles < ActiveRecord::Migration
  def change
    create_table :sokkoji_articles do |t|
      t.string :title
      t.integer :user_id
      t.integer :board_id
      t.text :body
      t.integer :view_count, :default => 0

      t.timestamps
    end
  end
end
