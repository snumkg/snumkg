#encoding: utf-8
class SokkojiArticlesController < ApplicationController
  before_filter :check_signin, :except => [:index, :show]
  def index
    @sokkoji_articles = Article.where(:article_type => 1).order("created_at desc")
    @index = @sokkoji_articles.count
  end

  def new
    @board = Board.find_by_board_type(1)
    @sokkoji_article = @board.articles.new
  end

  def show
    @sokkoji_article = Article.find_by_id(params[:id])
  end

  def edit
    @sokkoji_article = SokkojiArticle.find_by_id(params[:id])
  end

  def update
    @sokkoji_article = SokkojiArticle.find_by_id(params[:id]) 
    @sokkoji_article.update_attributes(title: params[:sokkoji_article][:title],
                                       day:params[:sokkoji_article][:day],
                                       body:params[:sokkoji_article][:body])

    redirect_to sokkoji_article_path(group_name: @sokkoji_article.board.group.name, board_name: params[:board_name], id: params[:id])
  end

  def create
    @sokkoji_article = Article.new(params[:article])
    
    @sokkoji_article.user_id = current_user.id
    @sokkoji_article.board_id = Board.find_by_board_type(1)
    @sokkoji_article.article_type = 1

    if @sokkoji_article.save
      redirect_to sokkoji_articles_path(group_name: params[:group_name], board_name: params[:board_name])
    else
      render 'new'
    end
  end

  def destroy
    @sokkoji_article = SokkojiArticle.find(params[:id])

    @sokkoji_article.destroy

    redirect_to sokkoji_articles_path(group_name: params[:group_name], board_name: params[:board_name])
  end
end
