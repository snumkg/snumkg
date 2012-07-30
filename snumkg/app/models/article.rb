class Article < ActiveRecord::Base
  attr_protected
  validates_presence_of :user_id, :board_id

  belongs_to :board
  belongs_to :writer, :class_name => 'User', :foreign_key => :user_id

  has_many :comments, :dependent => :destroy
  has_many :likes, :dependent => :destroy
  has_many :attendances, :dependent => :destroy

  def liked_by?(user_id)
    !Like.where(:article_id => self.id, :user_id => user_id).limit(1).first.nil?
  end

  def liked_by_users
    Like.where(:article_id => self.id).map {|like| like.user}
  end

  def attendanced_by?(user)
    !Attendance.where(:article_id => self.id, :user_id => user.id).limit(1).first.nil?
  end
end
