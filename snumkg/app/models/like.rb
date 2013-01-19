#encoding: utf-8
class Like < ActiveRecord::Base
  # attr_accessible :title, :body
  include AlarmHelper

  after_create :save_alarm
  before_destroy :destroy_alarm

  belongs_to :article
  belongs_to :comment
  belongs_to :user

  validates_presence_of :user_id
  validates_uniqueness_of :article_id, :scope => :user_id, :unless => Proc.new {|like| like.article_id.nil?}
  validates_uniqueness_of :comment_id, :scope => :user_id, :unless => Proc.new {|like| like.comment_id.nil?}

  #validate :article_xor_comment # article_id나 comment_id둘중 하나는 반드시 값을 가져야 함. 둘다 가져서는 안됨.

  private

=begin  # Like모델은 article_id나 comment_id 둘중 하나를 반드시 가져야함.
  def article_xor_comment
    if !(article_id.nil? ^ comment_id.nil?) # XOR 연산
      errors.add_to_base("Specify article_id or comment_id, not both")
    end
  end
=end
  def save_alarm
    if self.comment_id
      # 코멘트를 추천할 때
      if self.comment.writer and self.user and self.comment.article and self.comment
        save_alarm_helper(accepter_id: self.comment.writer.id,
                          alarmer_id: self.user.id,
                          article_id: self.comment.article.id,
                          comment_id: self.comment.id,
                          alarm_type: "댓글추천")
      end
    elsif self.article_id
      # 글을 추천할 때
      if self.article.writer and self.user and self.article
        save_alarm_helper(accepter_id: self.article.writer.id,
                          alarmer_id: self.user.id,
                          article_id: self.article.id,
                          alarm_type: "글추천")
      end
    end
  end

  def destroy_alarm
    if self.comment_id
      # 코맨트 추천 취소
      if self.comment.writer and self.user and self.comment.article and self.comment
        destroy_alarm_helper(:accepter_id => self.comment.writer.id,
                             :alarmer_id => self.user.id,
                             :article_id => self.comment.article.id,
                             :comment_id => self.comment.id,
                             :alarm_type => "댓글추천")
      end
    elsif self.article_id
      # 글 추천 취소
      if self.article.writer and self.user and self.article
        destroy_alarm_helper(:accepter_id => self.article.writer.id,
                             :alarmer_id => self.user.id,
                             :article_id => self.article.id,
                             :alarm_type => "글추천")
      end
    end
  end

  public

end
