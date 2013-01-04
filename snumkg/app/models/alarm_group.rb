#coding: utf-8
class AlarmGroup < ActiveRecord::Base
  attr_protected
  # type
  # 0 : 글을 추천할때
  # 1 : 글에 댓글을 달 때
  # 2 : 댓글을 추천할 때
  # 3 : 프로필에 댓글을 달 때
  # 4 : 소꼬지에 참석할 때
  belongs_to :user, :class_name => 'User', :foreign_key => :accepter_id
  belongs_to :article
  belongs_to :comment
  validates_presence_of :accepter_id
  validates_uniqueness_of :accepter_id, :scope => [:article_id, :comment_id, :alarm_type]
  has_many :alarms, :dependent => :delete_all

  after_save :check_alarm

  def alarm_text
    #알람을 묶어 알람 텍스트 생성
    case self.alarm_type
    when 0
      "글추천"
    when 1
      "댓글"
    when 2
      "댓글추천"
    when 3
      "프로필댓글"
    when 4
      "참석"
    end
  end

  def type_text
    case self.alarm_type
    when 0
      "글추천"
    when 1
      "댓글"
    when 2
      "댓글추천"
    when 3
      "프로필댓글"
    when 4
      "참석"
    end
  end

  def check_alarm
    #AlarmGroup이 가지고 있는 Alarm이 없으면 삭제
    if self.alarams.size == 0 then
      self.destroy
    end
  end
end
