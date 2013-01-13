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
    alarm_group.state = 0
    alarm_group.refreshed_at = Time.now
    if alarm_group.save
    else
      raise hash.to_s
    end

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
                           :alarm_type => hash[:alarm_type]).limit(1).first
      if alarm_group then
        alarm_group.alarms.where(:alarmer_id => hash[:alarmer_id]).each do |alarm|
          alarm.destroy
        end
      end
    end
  end
end
