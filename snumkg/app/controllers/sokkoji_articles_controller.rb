#encoding: utf-8
class SokkojiArticlesController < ApplicationController
  before_filter :check_signin, :except => [:index, :show]
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

  def edit
    @sokkoji_article = SokkojiArticle.find_by_id(params[:id])
  end

  def update
    @sokkoji_article = SokkojiArticle.find_by_id(params[:id]) 
    @sokkoji_article.update_attributes(title: params[:sokkoji_article][:title],
                                       day:params[:sokkoji_article][:day],
                                       body:params[:sokkoji_article][:body])

    redirect_to sokkoji_article_path(tab_name: @sokkoji_article.board.tab.name, id: params[:id])
  end

  def create
    @sokkoji_article = SokkojiArticle.new(params[:sokkoji_article])
    
    @sokkoji_article.user_id = current_user.id
    @sokkoji_article.board_id = Board.find_by_board_type(1)

    if @sokkoji_article.save
      redirect_to sokkoji_articles_path(tab_name: params[:tab_name])
    else
      render 'new'
    end
  end

  def destroy
    @sokkoji_article = SokkojiArticle.find(params[:id])

    @sokkoji_article.destroy

    redirect_to sokkoji_articles_path(tab_name: params[:tab_name])
  end
end
