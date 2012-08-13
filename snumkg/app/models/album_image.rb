class AlbumImage < ActiveRecord::Base
  attr_accessible :article_id, :full_path

  before_destroy :destroy_image

  belongs_to :article


  private
  def destroy_image
    File.delete(self.full_path)
  end
end
