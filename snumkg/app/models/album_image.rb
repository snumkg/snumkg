class AlbumImage < ActiveRecord::Base
  attr_accessible :article_id, :full_path

  before_destroy :destroy_image

  belongs_to :article



  def to_jq_upload
    case self.type
    when "album"
    {
      "name" => self.name,
      "size" => self.size,
      "url" => image_path(type: self.type, id: self.id),
      "thumbnail_url" => avatar.thumb.url,
      "delete_url" => image_path(type: self.type,:id => id),
      "delete_type" => "DELETE" 
    }
    when
    end
  end
end
