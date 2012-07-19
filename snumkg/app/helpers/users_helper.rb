#encoding: utf-8
module UsersHelper
  def to_article_path(tab_name,board_name,article_id)
    article_path(tab_name: tab_name, board_name: board_name, id: article_id)
  end

  def create_article_link(string,tab_name,board_name,article_id)
    link_to string, to_article_path(tab_name, board_name, article_id) 
  end

  def alarm_messages(alarm)
    article = alarm.article
    tab_name = article.board.tab.name
    board_name = article.board.name

    case alarm.alarm_type
    when 0
      create_article_link("글을 추천하였습니다.",tab_name,board_name,article.id)
    when 1
      create_article_link("글에 댓글을 달았습니다.",tab_name,board_name,article.id)
    when 2
      create_article_link("댓글을 추천하였습니다.",tab_name,board_name,article.id)
    when 3
      create_article_link("댓글에 댓글을 달았습니다.",tab_name,board_name,article.id)
    end
   end
end
