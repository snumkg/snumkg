#encoding: utf-8
class LikeCommentsController < ApplicationController

  def create_alarm_like_comment(comment)
    #1. 코멘트 글쓴이에게  알람 발생
    if current_user != comment.user
      save_alarm(Alarm.new,comment.user.id,2, :article_id => comment.article.id, :comment_id => comment.id)
    end
    #2. 코멘트을 추천한 사람들에게 알람 발생
    for user in comment.liked_by_users
      if comment.user != user # 글쓴이와 추천자가 일치할 경우. 알람 제외 (중복 방지)
        save_alarm(Alarm.new,user.id,2, :article_id => comment.article.id, :comment_id => comment.id)
      end
    end

  end


  def like
    @like = LikeComment.new
    @like.comment_id = params[:comment_id]
    @like.user_id = current_user.id unless current_user.nil?

    @comment = Comment.find_by_id(params[:comment_id])
    create_alarm_like_comment(@comment)

    if @like.save
      redirect_to :back
    else
      flash[:error] = "잘못된 접근입니다."
      redirect_to root_path
    end
  end


  def unlike
    #추천 알림한 내용 제거
    @alarms = Alarm.where(comment_id: params[:comment_id], alarmer_id: current_user.id, alarm_type: 2)

    for alarm in @alarms
      destroy_alarm(alarm)
    end

    @like = LikeComment.where(:comment_id => params[:comment_id], :user_id => session[:user_id]).limit(1).first

    @like.destroy unless @like.nil?
    redirect_to :back
    
  end
end
