class CreateEverydayPosts < ActiveRecord::Migration
  def change
    create_table :everyday_posts do |t|
      t.string :content
      t.integer :user_id

      t.timestamps
    end
  end
end
