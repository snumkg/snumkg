#encoding: utf-8
module UsersHelper
  def to_article_path(group_name,board_name,article_id)
    article_path(group_name: group_name, board_name: board_name, id: article_id)
  end

  def create_article_link(string,group_name,board_name,article_id)
    link_to string, to_article_path(group_name, board_name, article_id) 
  end

  def create_profile_link(string,user_id)
    link_to string, profile_path(user_id)
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
  def alarm_messages_link(alarm)
    if alarm.alarm_type == 0 || alarm.alarm_type == 1 || alarm.alarm_type == 2 || alarm.alarm_type == 4
      article = alarm.article
      group_name = article.board.group.name
      board_name = article.board.name
    end

    case alarm.alarm_type
    when 0
      create_article_link("글을 추천하였습니다.",group_name,board_name,article.id)
    when 1
      create_article_link("글에 댓글을 달았습니다.",group_name,board_name,article.id)
    when 2
      create_article_link("댓글을 추천하였습니다.",group_name,board_name,article.id)
    when 3
      create_profile_link("#{alarm.acceptor.nickname}님의 프로필에 댓글을 달았습니다.",alarm.acceptor.id)
    when 4
      link_to "소꼬지에 참석합니다.", sokkoji_article_path(group_name: group_name , board_name: board_name, id: alarm.article.id)
    end
   end
end
