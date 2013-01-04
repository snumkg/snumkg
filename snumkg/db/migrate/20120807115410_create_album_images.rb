class CreateAlbumImages < ActiveRecord::Migration
  def change
    create_table :album_images do |t|
      t.integer :article_id
      t.string :full_path
      t.string :file_name

      t.timestamps
    end
  end
end
