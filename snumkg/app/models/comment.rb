class Comment < ActiveRecord::Base
  include AlarmHelper

  before_create :save_alarm
  #before_destroy :destroy_alarm

  attr_accessible :content

  belongs_to :article
  belongs_to :writer, :class_name => 'User', :foreign_key => :user_id
  belongs_to :profile_user, :class_name => 'User', :foreign_key => :profile_user_id

  has_many :likes, :dependent => :destroy
  has_many :alarms, :dependent => :destroy

  validates_presence_of :content, :user_id

  def liked_by?(user)
    !Like.where(:comment_id => self.id, :user_id => user.id).limit(1).first.nil?
  end

  def liked_by_users
    Like.where(:comment_id => self.id).map {|c| c.user}
  end

  private
  def save_alarm
    if self.profile_user_id.nil? 
      # profile_user_id가 nil 일 때
      # 게시물에다 코멘트를 다는 경우
      # 게시물 작성자에게 알림

      if self.article.article_type != 2
        save_alarm_helper(acceptor_id: self.article.writer.id, 
                          article_id: self.article_id,
                          comment_id: self.id,
                          alarmer_id: self.writer.id,
                          alarm_type: 1)

        #게시물에 댓글을 단 사람들에게 알림
        comment_writers = self.article.comments.map {|c| c.writer}

        for comment_writer in comment_writers
          if comment_writer != self.writer
            save_alarm_helper(acceptor_id: comment_writer.id,
                              article_id: self.article_id,
                              comment_id: self.id,
                              alarmer_id: self.writer.id,
                              alarm_type:  1)
          end
        end    
      end
    else
      # profile_user_id의 값이 존재할 때
      # 프로필 페이지에다 코멘트를 다는 경우  
      # 프로필 페이지의 유저에게 알림
      save_alarm_helper(acceptor_id: self.profile_user_id,
                        alarmer_id: self.writer.id,
                        alarm_type: 3)
    end
  end

=begin
  def destroy_alarm
    if self.profile_user_id.nil?
      destroy_alarm_helper(:article_id => self.article_id,
                           :alarmer_id => self.writer.id,
                           :alarm_type => 1)
    else
      destroy_alarm_helper(:alarmer_id => self.writer.id,
                           :alarm_type => 3)
    end

  end
=end
end
