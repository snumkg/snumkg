class ProfileComment < ActiveRecord::Base
   attr_accessible :content

   belongs_to :user
   belongs_to :writer, :class_name => "User", :foreign_key => "writer_id"
end
