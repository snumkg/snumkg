#encoding: utf-8
class Board < ActiveRecord::Base
  attr_protected

  # board_type 
  # "일반"
  # "익명"
  # "앨범"
  # "소꼬지 일정"
  # "소꼬지 게시판"
  # "매일매일"
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
