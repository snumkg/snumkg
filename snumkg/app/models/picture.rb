class Picture < ActiveRecord::Base
  attr_protected 

  belongs_to :article
  def to_jq_upload
    {
      "name" => self.name,
      "size" => "20",
      "url" => self.url,
      "thumb_url" => self.url,
      "id" => self.id,
      "delete_url" => self.url,
      "delete_type" => "DELETE" 
    }
  end

end

