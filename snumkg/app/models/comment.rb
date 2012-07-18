class Comment < ActiveRecord::Base
  attr_accessible :content

  belongs_to :article
  belongs_to :user

  has_many :like_comments

  validates_presence_of :content, :article_id, :user_id

  def liked_by?(user)
    !LikeComment.where(:comment_id => self.id, :user_id => user.id).limit(1).first.nil?
  end
end
