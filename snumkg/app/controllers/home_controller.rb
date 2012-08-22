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
      @all_article = Article.order("created_at DESC")[0..4]
      @photos = Picture.where("article_id is not null")[0..4]

    end
  end

  def group
  end

  def all
    @all = Article.all + Comment.all + Like.all + Attendance.all 
    @all.sort! do |a,b|
      a.created_at < b.created_at ? 1 : -1
    end
  end

end
