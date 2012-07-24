class CreateProfileComments < ActiveRecord::Migration
  def change
    create_table :profile_comments do |t|
      t.integer :user_id
      t.integer :writer_id
      t.string :content
      t.timestamps
    end
  end
end
