class CommentsController < ApplicationController

  def create_comment_at_article_alarm(article)
    #1. 글쓴이에게 코멘트 알림
    if current_user != article.user
    save_alarm(Alarm.new,article.user.id,1,article.id)
    end
    #2. 글에 댓글 단 사람들에게 코멘트 알림
    users = article.comments.map {|comment| comment.user}
    for user in users.uniq # 여러 댓글을 단 사람들 중복 제거
      if current_user != user && article.user != user
      save_alarm(Alarm.new,user.id,1,article.id)
      end
    end
    #3. 글 추천한 사람에게 코멘트 알림(?)
  end

  def create
    tab_name = params[:comment][:tab_name]
    board_name = params[:comment][:board_name]

    @comment = Comment.new
    @comment.content = params[:comment][:content]
    @comment.article_id = params[:comment][:article_id]
    @comment.user_id = params[:comment][:user_id]

    #알람 create
    @article = Article.find_by_id(params[:comment][:article_id]) 
    create_comment_at_article_alarm(@article)

    if @comment.save
      redirect_to article_path(tab_name: tab_name, board_name: board_name, id: params[:comment][:article_id])

    else
      redirect_to article_path(tab_name: tab_name, board_name: board_name, id: params[:comment][:article_id])  
    end
  end


  def destroy_comment_at_article_alarm(alarm)
    user = alarm.acceptor

    user.update_attribute(:alarm_counts, user.alarm_counts - 1)
    alarm.destroy unless alarm.nil?
  end

  def destroy
    comment = Comment.find_by_id(params[:id])

    # 내가 단 코멘트로 인해 발생한 알람을 모두 지우기.
    # 1. 글쓴이에게 알람 발생시킨 것 제거
    # 2. 코멘트 단 사람들에게 알람 발생시킨 것 제거...가아니라
    # 그냥 Alarm.where(article_id: a.id, alarmer_id: me, alarm_type: 1)로 찾아서 다 제거.

    @alarms = Alarm.where(article_id: comment.article.id, alarmer_id: current_user.id, alarm_type: 1)

    for alarm in @alarms
      destroy_comment_at_article_alarm(alarm) 
    end

    if comment.destroy
      redirect_to :back
    else

    end
    
  end
end
