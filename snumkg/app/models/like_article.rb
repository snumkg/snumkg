class LikeArticle < ActiveRecord::Base

  belongs_to :article
  belongs_to :user

  validates_presence_of :article_id, :user_id
  validates_uniqueness_of :article_id, :scope => :user_id
end
