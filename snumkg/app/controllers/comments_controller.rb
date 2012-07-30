class CommentsController < ApplicationController

  def create_comment_at_article_alarm(article)
    #1. 글쓴이에게 코멘트 알림
    if current_user != article.writer
    save_alarm(Alarm.new,article.writer.id,1,:article_id => article.id)
    end
    #2. 글에 댓글 단 사람들에게 코멘트 알림
    writers = article.comments.map {|comment| comment.writer}
    for writer in writers.uniq # 여러 댓글을 단 사람들 중복 제거
      if current_user != writer && article.writer != writer
      save_alarm(Alarm.new,writer.id,1,:article_id => article.id)
      end
    end
    #3. 글 추천한 사람에게 코멘트 알림(?)
  end

  def create
    #게시물에 코멘트가 달렸을 때
    group_name = params[:comment][:group_name]
    board_name = params[:comment][:board_name]

    @comment = Comment.new
    @comment.content = params[:comment][:content]
    @comment.article_id = params[:comment][:article_id]
    @comment.user_id = params[:comment][:user_id]
    @comment.comment_type = 0

=begin
    #알람 create
    @article = Article.find_by_id(params[:comment][:article_id]) 
    create_comment_at_article_alarm(@article)
=end
    if @comment.save
      redirect_to article_path(group_name: group_name, board_name: board_name, id: params[:comment][:article_id])

    else
      redirect_to article_path(group_name: group_name, board_name: board_name, id: params[:comment][:article_id])  
    end
  end

  def destroy
    comment = Comment.find_by_id(params[:id])

    # 내가 단 코멘트로 인해 발생한 알람을 모두 지우기.
    # 1. 글쓴이에게 알람 발생시킨 것 제거
    # 2. 코멘트 단 사람들에게 알람 발생시킨 것 제거...가아니라
    # 그냥 Alarm.where(article_id: a.id, alarmer_id: me, alarm_type: 1)로 찾아서 다 제거.

    if comment.destroy
      redirect_to :back
    else
      redirect_to root_path
    end
    
  end
end
