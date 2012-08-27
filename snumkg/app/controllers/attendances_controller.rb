class AttendancesController < ApplicationController

  def create_attendance_alarm(article)
    #1. 글쓴이에게  알람 발생
    if current_user != article.user
      save_alarm(Alarm.new,article.user.id,4, :article_id => article.id)
    end
=begin
    이 부분은 삭제(?)( 너무 알림이 많아지는 것 같음)
    #2. 글을 추천한 사람들에게 알람 발생
    for user in article.liked_by_users
      if article.user != user # 글쓴이와 추천자가 일치할 경우. 알람 제외 (중복 방지)
        save_alarm(Alarm.new,user.id,0, :article_id => article.id)
      end
    end
=end
  end



  def create
    @article = Article.find_by_id(params[:id])

    @attendance = Attendance.new
    @attendance.article_id = params[:id]
    @attendance.user_id = current_user.id

    if @attendance.save

      respond_to do |format|
        format.html {redirect_to :back}
        format.js

      end
    end

  end

  def destroy
    @attendance = Attendance.where(article_id: params[:id], user_id: current_user.id).limit(1).first
    @article = Article.find_by_id(params[:id])
    
    if @attendance.destroy
      respond_to do |format|
        format.html {redirect_to :back}
        format.js 
      end
    end

    
  end
end
