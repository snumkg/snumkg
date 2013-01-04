#encoding: utf-8
class Board < ActiveRecord::Base
  attr_protected

  # board_type 
  # 0: "일반"
  # 1: "익명"
  # 2: "앨범"
  # 3: "소꼬지 일정"
  # 4: "소꼬지 게시판"
  # 5: "매일매일"
  has_many :articles
  belongs_to :group

  def type_text
    case self.board_type
    when 0
      "일반"
    when 1
      "익명"
    when 2
      "앨범"
    when 3
      "소꼬지 일정"
    when 4
      "소꼬지"
    when 5
      "매일매일"
    end
  end

  def new_article?

    if !self.articles.where("created_at >= ?", Time.now.yesterday.yesterday).limit(1).empty?
      true
    else
      false
    end
  end

  private
end
