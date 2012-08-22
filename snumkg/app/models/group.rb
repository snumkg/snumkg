class Group < ActiveRecord::Base
  # attr_accessible :title, :body
  # group_type
  # "일반"
  # "소꼬지"
  #
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

end
