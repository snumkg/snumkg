class CreatePictures < ActiveRecord::Migration
  def change
    create_table :pictures do |t|
      t.string :full_path
      t.string :size
      t.string :url
      t.string :name
      t.string :thumb_path
      t.string :thumbnail_url
      t.integer :article_id 

      t.timestamps
    end
  end
end