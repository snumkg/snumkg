#encoding: utf-8
class SokkojiArticlesController < ApplicationController
  def index
    @sokkoji_articles = SokkojiArticle.order("created_at desc")
    @index = @sokkoji_articles.count
  end

  def new
    @board = Board.find_by_board_type(1)
    @sokkoji_article = @board.sokkoji_articles.new
  end

  def show
    @sokkoji_article = SokkojiArticle.find_by_id(params[:id])
  end

  def parseDay(string)
    arr = string.split("년")
    year = arr.first
    arr = arr.last.split("월")
    month = arr.first
    arr = arr.last.split("일")
    day = arr.first
    
    arr.last.strip!
    hour = arr.split("시").first
    arr = arr.last.split("분")
    minute = arr.first

    return {year: year, month: month, day: day, hour: hour, minute: minute}
  end

  def create
    @sokkoji_article = SokkojiArticle.new(params[:sokkoji_article])
    
    @sokkoji_article.user_id = current_user.id

    if @sokkoji_article.save
      redirect_to sokkoji_articles_path(tab_name: params[:tab_name])
    else
      render 'new'
    end
  end
end
