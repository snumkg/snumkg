#coding: utf-8
class AlarmGroup < ActiveRecord::Base
  include AlarmHelper
  include Rails.application.routes.url_helpers
  include ActionDispatch::Routing::UrlFor
  attr_protected
  # type
  # 0: 글을 추천할때 : 글추천
  # 1: 글에 댓글을 달 때 : 댓글
  # 2: 댓글을 추천할 때 : 댓글추천
  # 3: 프로필에 댓글을 달 때 : 프로필댓글
  # 4: 소꼬지에 참석할 때 : 참석
  
  belongs_to :user, :class_name => 'User', :foreign_key => :accepter_id
  belongs_to :article
  belongs_to :comment
  validates_presence_of :accepter_id
  validates_uniqueness_of :accepter_id, :scope => [:article_id, :comment_id, :alarm_type]
  has_many :alarms, :dependent => :delete_all

  #알람 메시지를 생성하기 위한 메소드들
  def alarm_profile_picture
    self.alarms.order("updated_at DESC").limit(1).first.alarmer.profile_image_thumb_url
  end

  def alarm_text
    #알람을 묶어 알람 텍스트 생성
    @people = self.alarms.order("updated_at DESC").map{|x| User.find_by_id(x.alarmer_id).nickname}

    # 알림 인원이 3명 이하일땐 이름을 모두 표시
    if @people.size <= 3 then
      @people_text = @people.join(", ") + "님이"
    else
      @people_text = @people[0..2].join(", ") + " 외 #{@people.size - 3}명이"
    end

    @article = self.article
    @comment = self.comment

    case self.alarm_type
    when "글추천"
      "#{@people_text} #{@article.title}글을 추천하였습니다."
    when "댓글"
      "#{@people_text} 글에 댓글을 달았습니다."
    when "댓글추천"
      "#{@people_text} 댓글을 추천하였습니다."
    when "프로필댓글"
      "#{@people_text} 프로필에 댓글을 달았습니다."
    when "참석"
      "#{@people_text} 참석합니다."
    end
  end

  def link_url
    article = self.article
    comment = self.comment
    if article then
      board = article.board
      group = board.group
    end

    if article then
      article_path(group_id: group.id, board_id: board.id, id: article.id)
    elsif self.alarm_type == '프로필댓글'
      profile_path(self.user)
    end
  end

  #refreshed_at을 상대적인 시간으로 표시함
  def relative_time
    diff = Time.now - self.refreshed_at
    minutes = (diff / 60).to_i
    hours = (diff / 3600).to_i
    days = (diff / (3600*24)).to_i
    if diff < 60
      "1분 전"
    elsif diff < 3600
      "#{minutes}분 전"
    elsif diff < 3600 * 24
      "#{hours}시간 전"
    elsif diff < 3600 * 24 * 3
      "#{days}일 전"
    else
      self.refreshed_at.strftime("%Y년 %m월 %d일")
    end
  end

end
