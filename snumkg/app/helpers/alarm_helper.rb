#coding: utf-8
module  AlarmHelper
  def save_alarm_helper(hash = {})
    if hash[:accepter_id] == hash[:alarmer_id] then return end

    if hash[:alarm_type] == '글추천' or hash[:alarm_type] == '댓글추천' or hash[:alarm_type] == '참석' then
      #익명게시판이면 알람 생성 하지 않음
      article = Article.find_by_id(hash[:article_id])
      return false if article.article_type == '익명'
    end

    if hash[:alarm_type] == '댓글' then
      #댓글 생성
      alarm_group = AlarmGroup.find_or_create_by_accepter_id_and_article_id_and_alarm_type(
        hash[:accepter_id],
        hash[:article_id],
        hash[:alarm_type]
      )
      alarm_group.comment_id = hash[:comment_id]
    else
      alarm_group = AlarmGroup.find_or_create_by_accepter_id_and_article_id_and_comment_id_and_alarm_type(
        hash[:accepter_id],
        hash[:article_id],
        hash[:comment_id],
        hash[:alarm_type]
      )
    end
    alarm_group.is_new = true
    alarm_group.save

    alarm = Alarm.create(
      alarm_group_id: alarm_group.id,
      alarmer_id: hash[:alarmer_id]
    )

  end

  def destroy_alarm_helper(hash = {})
    if hash[:accepter_id] != hash[:alarmer_id]
      alarm_group = AlarmGroup.where(:accepter_id => hash[:accepter_id],
                           :article_id => hash[:article_id],
                           :comment_id => hash[:comment_id],
                           :alarm_type => hash[:alarm_type]).first
      alarm_group.alarms.where(:alarmer_id => hash[:alarmer_id]).each do |alarm|
        alarm.destroy
      end
    end
  end

  def to_article_path(group_id,board_id,article_id)
    article_path(group_id: group_id, board_id: board_id, id: article_id, type: "click_alarm")
  end

  #알람 텍스트를 위한 핼퍼
  def create_article_link(string,group_id,board_id,article_id)
    ActionController::Base.helpers.link_to string, to_article_path(group_id, board_id, article_id) 
  end

  def create_profile_link(string,user_id)
    ActionController::Base.helpers.link_to string, profile_path(user_id, type: "click_alarm")
  end

  def show_alarm_messages(alarms)
    msg = ""
    if alarms.count <= 3 
      cnt = 0 
      # 알림 인원이 3명 이하일땐 이름을 모두 표시
      for alarm in alarms 
        cnt = cnt + 1 
        msg = msg + alarm.alarmer.nickname
        msg = msg + "," unless cnt == alarms.count
      end
      msg.strip!
      msg = msg + "님이 "
    else
      #TODO알림 인원이 3명 이상일땐, ~~외 몇명이 추천하였습니다.-->
      cnt = 0
      alarms[0..2].each do |alarm|
        cnt = cnt + 1
        msg = msg +"#{alarm.alarmer.nickname}"
        msg = msg + "," unless cnt == 3
      end
      msg = msg + "외 #{alarms.count - 3}명이 "
    end
   
  end
  def alarm_messages_link(alarms)
    alarm = alarms[0]
    if alarm.alarm_type == 0 || alarm.alarm_type == 1 || alarm.alarm_type == 2 || alarm.alarm_type == 4
      article = alarm.article
      group_id = article.board.group.id
      board_id = article.board.id
    end

    case alarm.alarm_type
    when 0
      create_article_link("#{show_alarm_messages(alarms)}글을 추천하였습니다.",group_id,board_id,article.id)
    when 1
      create_article_link("#{show_alarm_messages(alarms)}글에 댓글을 달았습니다.",group_id,board_id,article.id)
    when 2
      create_article_link("#{show_alarm_messages(alarms)}댓글을 추천하였습니다.",group_id,board_id,article.id)
    when 3
      create_profile_link("#{show_alarm_messages(alarms)}프로필에 댓글을 달았습니다.",alarm.acceptor.id)
    when 4
      create_article_link("#{show_alarm_messages(alarms)}소꼬지에 참석합니다.",group_id,board_id,article.id)
    end
   end

end
