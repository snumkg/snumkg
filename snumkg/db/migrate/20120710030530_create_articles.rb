class CreateArticles < ActiveRecord::Migration
  def change
    create_table :articles do |t|
      t.integer :user_id
      t.integer :board_id
      t.string  :title
      t.text    :body
      t.integer :view_count, :default => 0

      t.timestamps
    end
  end
end
