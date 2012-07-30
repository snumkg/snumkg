class Profile < ActiveRecord::Base
  attr_accessible :comment_id, :user_id
  
  has_many :comments
end
