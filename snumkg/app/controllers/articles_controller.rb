#encoding: utf-8
class ArticlesController < ApplicationController
  before_filter :check_signin, except: [:index, :show]
  def index

    @board = @boards.find_by_id(params[:board_id])
    @articles = @board.articles.order("created_at desc")

    @index = @articles.count

    case @board.board_type
    when 0 # 일반게시판
      render 'index'
    when 1 # 소꼬지 게시판
      render 'sokkoji_index'
    when 2 # 익명게시판
      render 'anonymous_index'
    when 3 # 앨범게시판
      render 'album_index'
    end
  end

  def new
    @board = Board.find_by_id(params[:board_id])
    @article = Article.new
    case @board.board_type
    when 0 # 일반게시판
      render 'new'
    when 1 # 소꼬지게시판
      render 'sokkoji_new'
    when 2 # 익명게시판
      render 'anonymous_new'
    when 3 # 앨범게시판
      render 'album_new'
    end
  end

  def edit
    @article = Article.find_by_id(params[:id])

    case @article.article_type
    when 0 # 일반게시물
      render 'edit'
    when 1 # 소꼬지게시물
      render 'sokkoji_edit'
    when 2 # 일반게시물

    end
  end

  def update
    @article = Article.find_by_id(params[:id])

    @article.title = params[:article][:title]
    @article.body = params[:article][:body]
    @article.article_type = params[:article_type]

    if @article.save
      redirect_to article_path(group_id: @article.board.group.id, board_id: @article.board.id, id: params[:id])
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
    when 2 # 익명게시물
      render 'anonymous_show'
    end
  end

  def create
    @board = Board.find_by_id(params[:board_id])

    @article = Article.new(params[:article])
    @article.board_id = @board.id
    @article.article_type = params[:article_type]

    #익명게시물일 경우 유저 아이디를 저장하지 않음.
    if @article.article_type != 2
      @article.user_id = session[:user_id]
    else
      @article.set_password(params[:password])
    end

    if @article.save
      redirect_to articles_path(:group_id => params[:group_id], :board_id => params[:board_id])
    else
      case params[:article_type]
      when 0
        render 'new'
      when 1
        render 'sokkoji_new'
      when 2
        render 'anonymous_new'
      end

    end
  end

  def destroy
    @article = Article.find_by_id(params[:id])

    if @article.article_type == 2 # 익명게시물 삭제시
      if !@article.authentication(params[:password])
        flash[:error] = "비밀번호가 일치하지 않습니다."
        redirect_to article_path(:group_id => params[:group_id], :board_id => params[:board_id], id: params[:id])
        return
      end
      @article.destroy
    end

    redirect_to articles_path(:group_id => params[:group_id], :board_id => params[:board_id])
  end

  def password_confirmation

  end

end
