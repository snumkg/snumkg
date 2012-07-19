#encoding: utf-8
module UsersHelper

  def alarm_messages(alarm)
    if alarm.has_attribute?("article_id")
      article = alarm.article
      case alarm.alarm_type
      when 0
        link_to '글', article_path(tab_name: article.board.tab.name, board_name: article.board.name, id: article.id)
      when 1
        "글에 댓글을 달았습니다."
      end
    else
      case alarm.alarm_type
      when 0
        "댓글을 추천하였습니다."
      when 1
        "댓글을 달았습니다."
      end
    end
  end
end
