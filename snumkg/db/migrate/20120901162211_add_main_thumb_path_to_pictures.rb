class AddMainThumbPathToPictures < ActiveRecord::Migration
  def change
  	add_column :pictures, :main_thumb_path, :string
  	add_column :pictures, :main_thumb_url, :string
  end
end
