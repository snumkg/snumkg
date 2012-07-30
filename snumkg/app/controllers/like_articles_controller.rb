#coding: utf-8
class LikeArticlesController < ApplicationController

  def like
    @like = Like.new
    @like.article_id = params[:article_id]
    @like.user_id = session[:user_id]
    if !@like.errors.any?
      @result = @like.article.likes.map{|like| like.user.nickname}
      @like.save
    else
      @result = {error: "이미 추천하셨습니다."}
    end

    respond_to do |format|
      format.json {render :json => @result}
      format.html {redirect_to :back}
    end
  end

=begin
  def unlike
    #추천 알림한 내용 제거
    @alarms = Alarm.where(article_id: params[:article_id], alarmer_id: current_user.id, alarm_type: 0)

    for alarm in @alarms
      destroy_alarm(alarm)
    end

    #추천 제거
    @like = LikeArticle.where(:article_id => params[:article_id], :user_id => session[:user_id]).limit(1).first
    @like.destroy unless @like.nil?
  
    redirect_to :back
  end
=end
end
