#coding: utf-8
class LikeArticlesController < ApplicationController

  def create_alarm_like_article(article)
    #1. 글쓴이에게  알람 발생
    if current_user != article.user
      save_alarm(Alarm.new,article.user.id,0, article.id)
    end
    #2. 글을 추천한 사람들에게 알람 발생
    for user in article.liked_by_users
      if article.user != user # 글쓴이와 추천자가 일치할 경우. 알람 제외 (중복 방지)
        save_alarm(Alarm.new,user.id,0, article.id)
      end
    end

  end

  def like
    @like = LikeArticle.new
    @like.article_id = params[:article_id]
    @like.user_id = session[:user_id]
    if !@like.errors.any?
      @result = @like.article.like_articles.map{|like| like.user.nickname}
    #글을 추천받았을 경우 알람 발생!! 
    @article = Article.find_by_id(params[:article_id])
    create_alarm_like_article(@article)
   
    @like.save

    else
      @result = {error: "이미 추천하셨습니다."}
    end

    respond_to do |format|
      format.json {render :json => @result}
      format.html {redirect_to :back}
    end
  end

  def destroy_like_article_alarm(alarm)
    user = alarm.acceptor

    user.update_attribute(:alarm_counts, user.alarm_counts - 1)
    alarm.destroy unless alarm.nil?
  end

  def unlike
    #추천 알림한 내용 제거
    @alarms = Alarm.where(article_id: params[:article_id], alarmer_id: current_user.id, alarm_type: 0)

    for alarm in @alarms
      destroy_like_article_alarm(alarm)
    end

    #추천 제거
    @like = LikeArticle.where(:article_id => params[:article_id], :user_id => session[:user_id]).limit(1).first
    @like.destroy unless @like.nil?
  
    redirect_to :back
  end
end
