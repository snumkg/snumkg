#encoding: utf-8
class Comment < ActiveRecord::Base
  include AlarmHelper

  after_create :save_alarm
  before_destroy :destroy_alarm

  attr_accessible :content

  belongs_to :article
  belongs_to :writer, :class_name => 'User', :foreign_key => :user_id
  belongs_to :profile_user, :class_name => 'User', :foreign_key => :profile_user_id

  has_many :likes, :dependent => :destroy
  has_many :alarms, :dependent => :destroy

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
    if self.profile_user_id.nil? 
      # profile_user_id가 nil 일 때
      # 게시물에다 코멘트를 다는 경우
      # 게시물 작성자에게 알림

      if self.article.article_type != "익명" # 익명게시물이 아닐 때
        # 글쓴이에게 알람 저장
        save_alarm_helper(acceptor_id: self.article.writer.id, 
                          article_id: self.article_id,
                          comment_id: self.id,
                          alarmer_id: self.writer.id,
                          alarm_type: 1)

=begin
        #게시물에 댓글을 단 사람들에게 알림
        #댓글을 여러번 단 사람들 중복 제거
        comment_writers = self.article.comments.uniq {|c| c.writer}

        for comment_writer in comment_writers
          if comment_writer != self.writer && comment_writer != self.article.writer
            # 코멘트 글쓴이와 댓글 쓴사람이 같을 때
            # 코멘트 글쓴이와 아티클 글쓴이가 같을 때
            # 알람을 생성하지 않음(중복알람 제거)
            save_alarm_helper(acceptor_id: comment_writer.id,
                              article_id: self.article_id,
                              comment_id: self.id,
                              alarmer_id: self.writer.id,
                              alarm_type:  1)
          end
        end    
=end
      end
    else
      # profile_user_id의 값이 존재할 때
      # 프로필 페이지에다 코멘트를 다는 경우  
      # 프로필 페이지의 유저에게 알림
      save_alarm_helper(acceptor_id: self.profile_user_id,
                        alarmer_id: self.writer.id,
                        comment_id: self.id,
                        alarm_type: 3)
    end
  end

  def destroy_alarm
    if self.comment_type == 0 # 게시판 댓글
      if self.article.article_type != "익명" # 익명게시판이 아닐 경우
        alarm = Alarm.where(:alarmer_id => self.writer.id, 
                            :comment_id => self.id, 
                            :acceptor_id => self.article.writer.id, 
                            :article_id => self.article.id, 
                            :alarm_type => 1).limit(1).first
        alarm.destroy
      end
    else  # 프로필 댓글
      alarm = Alarm.where(:alarmer_id => self.writer.id, acceptor_id: self.profile_user_id, :alarm_type => 3).limit(1).first
      alarm.destroy
    end
  end

end
