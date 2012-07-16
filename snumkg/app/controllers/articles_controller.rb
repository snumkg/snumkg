class ArticlesController < ApplicationController
  before_filter :check_signin, :except => [:index] 
  def index
    @board = @boards.find_by_url_name(params[:board_name])
    @articles = @board.articles.order("created_at desc")
  end

  def new
    @article = Article.new
  end

  def show
    @article = Article.find_by_id(params[:id])
    @comments = @article.comments
    @comment = @article.comments.new
  end

  def create
    @article = Article.new(params[:article])

    @article.user_id = session[:user_id]
    @article.board_id = @boards.find_by_url_name(params[:board_name]).id

    if @article.save
      redirect_to articles_path(:tab_name => params[:tab_name], :board_name => params[:board_name])
    else
      render 'new'
    end
  end
end
