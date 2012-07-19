class Article < ActiveRecord::Base
  attr_protected
  validates_presence_of :user_id, :board_id

  belongs_to :board
  belongs_to :user

  has_many :comments
  has_many :like_articles

  def liked_by?(user_id)
    !LikeArticle.where(:article_id => self.id, :user_id => user_id).limit(1).first.nil?
  end

  def liked_by_users
    LikeArticle.where(:article_id => self.id).map {|like| like.user}
  end
end
