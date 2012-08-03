class ArticlesController < ApplicationController
  before_filter :check_signin, except: [:index, :show]
  def index

    @board = @boards.find_by_name(params[:board_name])
    @articles = @board.articles.order("created_at desc")

    @index = @articles.count

    case @board.board_type
    when 0 # 일반게시판
      render 'index'
    when 1 # 소꼬지 게시판
      render 'sokkoji_index'
    end
  end

  def new
    @board = Board.find_by_name(params[:board_name])
    @article = Article.new
    case @board.board_type
    when 0 # 일반게시판
      render 'new'
    when 1 # 소꼬지게시판
      render 'sokkoji_new'
    end
  end

  def edit
    @article = Article.find_by_id(params[:id])

    case @article.article_type
    when 0 # 일반게시물
      render 'edit'
    when 1 # 소꼬지게시물
      render 'sokkoji_edit'
    end
  end

  def update
    @article = Article.find_by_id(params[:id])

    @article.title = params[:article][:title]
    @article.body = params[:article][:body]
    @article.article_type = params[:article_type]

    if @article.save
      redirect_to article_path(group_name: params[:group_name], board_name: params[:board_name], id: params[:id])
    end

  end

  def show

    @article = Article.find_by_id(params[:id])
    @comments = @article.comments
    @comment = @article.comments.new

    case @article.article_type
    when 0 # 일반게시물
      render 'show'
    when 1 # 소꼬지 게시물
      render 'sokkoji_show'
    end
  end

  def create
    @board = Board.find_by_name(params[:board_name])

    @article = Article.new(params[:article])
    @article.user_id = session[:user_id]
    @article.board_id = @board.id
    @article.article_type = params[:article_type]

    if @article.save
      redirect_to articles_path(:group_name => params[:group_name], :board_name => params[:board_name])
    else
      case params[:article_type]
      when 0
        render 'new'
      when 1
        render 'sokkoji_new'
      end

    end
  end

  def destroy
    @article = Article.find_by_id(params[:id])
    
    if @article.destroy
      redirect_to articles_path(:group_name => params[:group_name], :board_name => params[:board_name])
     else
      redirect_to articles_path(:group_name => params[:group_name], :board_name => params[:board_name])
    end
  end
end
