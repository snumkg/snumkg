class Picture < ActiveRecord::Base
  # attr_accessible :title, :body
  def to_jq_upload
    {
      "name" => self.name,
      "size" => "20",
      "url" => self.url,
      "thumbnail_url" => self.url,
      "id" => self.id,
      "delete_url" => self.url,
      "delete_type" => "DELETE" 
    }
  end

end

