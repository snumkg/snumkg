#encoding: utf-8
class Comment < ActiveRecord::Base
  include AlarmHelper

  after_create :save_alarm, :set_newsfeed
  before_destroy :destroy_alarm

  attr_accessible :content

  belongs_to :article
  belongs_to :writer, :class_name => 'User', :foreign_key => :user_id
  belongs_to :profile_user, :class_name => 'User', :foreign_key => :profile_user_id

  has_many :likes, :dependent => :destroy

  validates_presence_of :content
  validates_presence_of :user_id, :unless => Proc.new {|comment| comment.article.nil? || comment.article.article_type == "익명"}


  def liked_by?(user)
    !Like.where(:comment_id => self.id, :user_id => user.id).limit(1).first.nil?
  end

  def liked_by_users
    Like.where(:comment_id => self.id).map {|c| c.user}
  end

  def authentication(password)
     if Digest::SHA256.hexdigest(password + self.password_salt) != self.password_hash
      false
    else
      true
    end
  end

  def set_password(pass)
    salt = [Array.new(6){rand(256).chr}.join].pack("m").chomp
    self.password_salt, self.password_hash = salt, Digest::SHA256.hexdigest(pass.to_s + salt)
  end


  private
  def save_alarm
    if self.profile_user_id
      # profile_user_id의 값이 존재할 때
      # 프로필 페이지에다 코멘트를 다는 경우  
      # 프로필 페이지의 유저에게 알림
      save_alarm_helper(accepter_id: self.profile_user_id,
                        alarmer_id: self.writer.id,
                        comment_id: self.id,
                        alarm_type: "프로필댓글")
    else
      # 게시물 작성자에게 알림
      # 글쓴이에게 알람 저장
      save_alarm_helper(accepter_id: self.article.writer.id, 
                        article_id: self.article_id,
                        comment_id: self.id,
                        alarmer_id: self.writer.id,
                        alarm_type: "댓글")
    end
  end

  def destroy_alarm
    if self.profile_user_id then
      #프로필 댓글
      destroy_alarm_helper(accepter_id: self.profile_user_id,
                           alarmer_id: self.writer.id,
                           comment_id: self.id,
                           alarm_type: "프로필댓글")
    else
      destroy_alarm_helper(accepter_id: self.article.writer.id, 
                           article_id: self.article_id,
                           comment_id: self.id,
                           alarmer_id: self.writer.id,
                           alarm_type: "댓글")
    end
  end

  def set_newsfeed
    news = Newsfeed.new
    news.comment_id = self.id
    news.save
  end

end
