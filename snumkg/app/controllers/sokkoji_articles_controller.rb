class SokkojiArticlesController < ApplicationController
  def index
    @sokkoji_articles = SokkojiArticle.order("created_at desc")
    @index = @sokkoji_articles.count
  end

  def new
    @board = Board.find_by_article_type(1)
    @sokkoji_article = @board.sokkoji_articles.new
  end

  def show
    @sokkoji_article = SokkojiArticle.find_by_id(params[:id])
  end
end
