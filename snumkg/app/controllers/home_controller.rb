#coding: utf-8
class HomeController < ApplicationController
  layout 'main'

  def index
    if params[:guest]
      session[:guest] = true
    end

    if session[:guest].nil? && current_user.nil?
      redirect_to signin_path
    else
      @all_article = Article.order("created_at DESC").limit(5)
      @photos = Picture.where("article_id is not null").order("created_at DESC").limit(4)
      @upcoming_sokkoji = Article.where("article_type = ? AND date >= ?","소꼬지", Time.now.yesterday.yesterday);
      @events = @upcoming_sokkoji
    end
  end

  def group
  end

  def all
    @page = params[:page] || 1
    @all = Newsfeed.order("created_at DESC").page(@page).per(10)

  end

end
