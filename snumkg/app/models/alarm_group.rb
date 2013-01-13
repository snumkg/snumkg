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

  def alarm_text
    #알람을 묶어 알람 텍스트 생성
    @people = self.alarms.order("updated_at DESC").map{|x| User.find_by_id(x.alarmer_id).nickname}

    # 알림 인원이 3명 이하일땐 이름을 모두 표시
    if @people.size <= 3 then
      @people_text = @people.join(", ") + "님이 "
    else
      @people_text = @people[0..2].join(", ") + " 외 #{@people.size - 3}명이 "
    end

    case self.alarm_type
    when "글추천"
      create_article_link("#{@people_text}글을 추천하였습니다.", self.article.board.group.id, self.article.board.id, self.article.id)
    when "댓글"
      create_article_link("#{@people_text}글에 댓글을 달았습니다.", self.article.board.group.id, self.article.board.id, self.article.id)
    when "댓글추천"
      "#{@people_text}댓글을 추천하였습니다."
    when "프로필댓글"
      "#{@people_text}프로필에 댓글을 달았습니다."
    when "참석"
      "#{@people_text}참석합니다."
    end
  end

end
