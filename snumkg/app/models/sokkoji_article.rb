class SokkojiArticle < ActiveRecord::Base
  attr_accessible :body, :title, :day

  has_many :comments, :dependent => :destroy
  has_many :attendances, :dependent => :destroy
  belongs_to :user
  belongs_to :board

  def attendanced_by?(user)
   !Attendance.where(:sokkoji_article_id => self.id, :user_id => user.id).limit(1).first.nil? 
  end
end
