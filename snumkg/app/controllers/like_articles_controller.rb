#coding: utf-8
class LikeArticlesController < ApplicationController

  def like
    @like = LikeArticle.new
    @like.article_id = params[:article_id]
    @like.user_id = session[:user_id]
    if @like.save
      @result = @like.article.like_articles.map{|like| like.user.nickname}
    else
      @result = {error: "이미 추천하셨습니다."}
    end

    respond_to do |format|
      format.json {render :json => @result}
      format.html {redirect_to :back}
    end
  end

  def unlike
    @like = LikeArticle.where(:article_id => params[:article_id], :user_id => session[:user_id]).limit(1).first

    @like.destroy unless @like.nil?
    redirect_to :back
  end
end
