class CreatePictures < ActiveRecord::Migration
  def change
    create_table :pictures do |t|
      t.string :full_path
      t.string :size
      t.string :url
      t.string :name
      t.string :thumb_path
      t.string :thumb_url
      t.integer :article_id 

      t.string :main_thumb_path
      t.string :main_thumb_url

      t.timestamps
    end
  end
end
