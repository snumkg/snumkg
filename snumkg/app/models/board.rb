class Board < ActiveRecord::Base
  attr_protected

  # board_type 
  # 0 :일반게시판
  # 1 : 소꼬지게시판
  # 2 : 익명게시판
  # 3 : 앨범게시판
  has_many :articles
  belongs_to :group


  def new_article?

    if !self.articles.where("created_at >= ?", Time.now.yesterday.yesterday).limit(1).empty?
      true
    else
      false
    end
  end

  private
end
