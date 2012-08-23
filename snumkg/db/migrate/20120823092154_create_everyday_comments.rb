class CreateEverydayComments < ActiveRecord::Migration
  def change
    create_table :everyday_comments do |t|
      t.string :content
      t.integer :user_id
      t.integer :everyday_post_id

      t.timestamps
    end
  end
end
