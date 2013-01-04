#encoding: utf-8
class Group < ActiveRecord::Base
  # attr_accessible :title, :body
  # group_type
  # 0: "일반"
  # 1: "소꼬지"
  # 2: "매일매일"
  attr_protected

  validates_uniqueness_of :name
  has_many :boards

  def new_article?
    
    for board in self.boards
      if board.new_article?
        return true
      end
    end

    false
  end

  def type_text
    case self.group_type
    when 0
      "일반"
    when 1
      "소꼬지"
    when 2
      "매일매일"
    end
  end

  def boards
    Board.where(group_id: self.id).order('position ASC')
  end

end
