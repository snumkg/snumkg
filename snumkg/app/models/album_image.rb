class AlbumImage < ActiveRecord::Base
  attr_accessible :article_id, :full_path

  belongs_to :article

end
