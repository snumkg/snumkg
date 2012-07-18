class LikeComment < ActiveRecord::Base
  #attr_accessible :comment_id, :user_id
  
  belongs_to :user
  belongs_to :comment

  validates_presence_of :comment_id, :user_id
  validates_uniqueness_of :comment_id, :scope => :user_id
 end
