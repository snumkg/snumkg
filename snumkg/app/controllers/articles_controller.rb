#encoding: utf-8
class ArticlesController < ApplicationController
  before_filter :check_signin, except: [:index]
  def index

    @board = @boards.find_by_id(params[:board_id])
    @notices = @board.articles.where(:is_notice => true).order("created_at desc")
    @page = params[:page].to_i || 1

    # Pagination
    if @board.board_type != "앨범" # 앨범은 보여주는 이미지의 갯수가 다르다.
      @articles = @board.articles.page(@page).order("created_at DESC").per(15)
    else
      @articles = @board.articles.page(@page).order("created_at DESC").per(6)
    end

    case @board.board_type
    when "일반", '익명', '소꼬지' then # 일반게시판
      render 'index'
    when "소꼬지 일정" # 소꼬지 달력
    # 소꼬지 일정을 보여줄 때, 소꼬지 게시판에서 게시물을 가져옴.
      @articles = Board.find_by_board_type("소꼬지").articles.page(@page).order("created_at DESC").per(10)
      render 'sokkoji_calendar'
    when "소꼬지" # 소꼬지 게시판
      # 소꼬지 게시물은 수정하면 다시 상단에 노출되도록 함
      # 똑같은 소꼬지 게시물을 새로 올리는 것을 방지하기 위해.

      #@articles = @board.articles.order("updated_at desc")
      render 'sokkoji_index'
    when "앨범"
      render 'album_index'
    end
  end

  def new
    @board = Board.find_by_id(params[:board_id])
    @article = Article.new
=begin
    case @board.board_type
    when "일반" # 일반게시판
      render 'new'
    when "소꼬지" # 소꼬지게시판
      render 'sokkoji_new'
    when "익명" # 익명게시판
      render 'anonymous_new'
    when "앨범" # 앨범게시판
      render 'album_new'
    end
=end
  end

  def edit
    @article = Article.find_by_id(params[:id])
    @board = @article.board

    @pictures = @article.pictures
=begin
    case @article.article_type
    when "일반" # 일반게시물
      render 'edit'
    when "소꼬지" # 소꼬지게시물
      render 'sokkoji_edit'
    when "익명" # 익명게시물
      render 'anonymous_edit'
    when "앨범" # 앨범게시물
      render 'album_edit'
    end
=end
  end

  def update
    @article = Article.find_by_id(params[:id])
    @article.update_attributes(params[:article])
    @article.date = params[:article][:date] unless params[:article][:date].nil? #소꼬지 일정 저장

    @article.title = params[:article][:title]
    @article.body = params[:article][:body]
    
    if @article.save
      redirect_to article_path(group_id: @article.board.group.id, board_id: @article.board.id, id: params[:id])

      #이미지 연결
      if params[:picture_ids] then
        @article.pictures.update_all(article_id: nil)
        Picture.where(:id => params[:picture_ids].split(",")).update_all(:article_id => @article.id)
      end
    end

  end

  def show
    @article = Article.find_by_id(params[:id])
    @comments = @article.comments
    @comment = Comment.new

    #조회수 증가
    @article.view_count = @article.view_count + 1
    @article.save 

    case @article.article_type
    when "일반", "익명" then # 일반게시물
      render 'show'
    when "소꼬지" # 소꼬지 게시물
      render 'sokkoji_show'
    when "앨범" # 앨범게시물
      @images = @article.pictures
      render 'album_show'
    end
  end

  def create
    @board = Board.find_by_id(params[:board_id])

    @article = Article.new(params[:article])
    @article.board_id = @board.id

    #익명게시물일 경우 유저 아이디를 저장하지 않음.
    if @board.board_type == "익명"
      @article.set_password(params[:password])
    else
      @article.user_id = session[:user_id]
    end

    if @article.save
      # picture_ids 저장
      if params[:picture_ids]
        Picture.where(:id => params[:picture_ids].split(",")).update_all(:article_id => @article.id)
      end

      respond_to do |format|
        format.html {redirect_to articles_path(:group_id => params[:group_id], :board_id => params[:board_id], page: 1)}
      end
    else
      render 'new'
=begin
      case params[:article_type]
      when "일반"
        render 'new'
      when "소꼬지"
        render 'sokkoji_new'
      when "익명"
        render 'anonymous_new'
      when "앨범"
        render 'album_new'
      end
=end
    end
  end

  def destroy
    @article = Article.find_by_id(params[:id])

    if @article.article_type == "익명" # 익명게시물 삭제시
      if !@article.authentication(params[:password])
        flash[:error] = "비밀번호가 일치하지 않습니다."
        redirect_to article_path(:group_id => params[:group_id], :board_id => params[:board_id], id: params[:id], page: 1)
        return
      end
      @article.destroy
    else
      @article.destroy
    end

    redirect_to articles_path(:group_id => params[:group_id], :board_id => params[:board_id], page: 1)
  end

  def password_confirmation
		#익명글 삭제 패스워드 확인
  end

end
