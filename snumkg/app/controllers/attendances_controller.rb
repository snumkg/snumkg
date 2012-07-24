class AttendancesController < ApplicationController

  def create
    @sokkoji_article = SokkojiArticle.find_by_id(params[:sokkoji_article_id])

    @attendance = Attendance.new
    @attendance.sokkoji_article_id = params[:sokkoji_article_id]
    @attendance.user_id = current_user.id
    @attendance.save

    redirect_to :back
  end

  def destroy
    
  end
end
