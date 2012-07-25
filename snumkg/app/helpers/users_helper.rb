#encoding: utf-8
module UsersHelper
  def to_article_path(tab_name,board_name,article_id)
    article_path(tab_name: tab_name, board_name: board_name, id: article_id)
  end

  def create_article_link(string,tab_name,board_name,article_id)
    link_to string, to_article_path(tab_name, board_name, article_id) 
  end

  def create_profile_link(string,user_id)
    link_to string, user_path(user_id)
  end

  def alarm_messages(alarm)
    if alarm.alarm_type == 0 || alarm.alarm_type == 1 || alarm.alarm_type == 2
      article = alarm.article
      tab_name = article.board.tab.name
      board_name = article.board.name
    end

    case alarm.alarm_type
    when 0
      create_article_link("글을 추천하였습니다.",tab_name,board_name,article.id)
    when 1
      create_article_link("글에 댓글을 달았습니다.",tab_name,board_name,article.id)
    when 2
      create_article_link("댓글을 추천하였습니다.",tab_name,board_name,article.id)
    when 3
      create_profile_link("#{alarm.acceptor.nickname}님의 프로필에 댓글을 달았습니다.",alarm.acceptor.id)
    when 4
      link_to "소꼬지에 참석합니다.", sokkoji_article_path(tab_name: "전체", id: alarm.sokkoji_article)
    end
   end
end
