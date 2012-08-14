class Group < ActiveRecord::Base
  # attr_accessible :title, :body
  attr_protected

  validates_uniqueness_of :name
  has_many :boards

  def new_article?
    
    for board in self.boards
      if !board.articles.where("created_at >= ?", Time.now.yesterday.yesterday).limit(1).empty?
        return true
      end
    end

    false
  end

end
