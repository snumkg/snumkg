class ArticlesController < ApplicationController
  before_filter :check_signin, except: [:index, :show]
  def index

    @board = @boards.find_by_name(params[:board_name])
    @articles = @board.articles.order("created_at desc")
    @index = @articles.count
  end

  def new
    @article = Article.new
  end
  def check_signin
    session[:url_back] = request.fullpath
    redirect_to signin_path unless signin?
  end

  def edit
    @article = Article.find_by_id(params[:id])
  end

  def show

    @article = Article.find_by_id(params[:id])
    @comments = @article.comments
    @comment = @article.comments.new
  end

  def create
    @article = Article.new(params[:article])

    @article.user_id = session[:user_id]
    @article.board_id = @boards.find_by_name(params[:board_name]).id

    if @article.save
      redirect_to articles_path(:tab_name => params[:tab_name], :board_name => params[:board_name])
    else
      render 'new'
    end
  end

  def destroy
    @article = Article.find_by_id(params[:id])
    
    if @article.destroy
      redirect_to articles_path(:tab_name => params[:tab_name], :board_name => params[:board_name])
     else
      redirect_to articles_path(:tab_name => params[:tab_name], :board_name => params[:board_name])
    end
  end
end
