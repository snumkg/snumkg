class AddFileNameToAlbumImages < ActiveRecord::Migration
  def change
    add_column :album_images, :file_name, :string
  end
end
