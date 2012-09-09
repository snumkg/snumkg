#encoding: utf-8
class ArticlesController < ApplicationController
  before_filter :check_signin, except: [:index]
  def index

    @board = @boards.find_by_id(params[:board_id])
    @notices = @board.articles.where(:notice => true).order("created_at desc")
    @notice_index = @notices.count

    # Pagination
    if @board.board_type != "앨범"
      @articles = @board.articles.page(params[:page].to_i).per(5)
    end

    @index = @articles.count

    case @board.board_type
    when "일반" # 일반게시판
      render 'index'
    when "소꼬지 일정" # 소꼬지 달력
    # 소꼬지 일정을 보여줄 때, 소꼬지 게시판에서 게시물을 가져옴.
      @articles = Board.find_by_board_type("소꼬지").page(params[:page].to_i).per(5)
                        .articles.order("created_at desc")
      render 'sokkoji_calendar'
    when "소꼬지" # 소꼬지 게시판
      # 소꼬지 게시물은 수정하면 다시 상단에 노출되도록 함
      # 똑같은 소꼬지 게시물을 새로 올리는 것을 방지하기 위해.

      @articles = @board.articles.order("updated_at desc")
      render 'sokkoji_index'
    when "익명" # 익명 게시판
      render 'anonymous_index'
    when "앨범"
      @articles = @board.articles.page(params[:page].to_i).per(6)
      render 'album_index'
    end
  end

  def new
    @board = Board.find_by_id(params[:board_id])
    @article = Article.new
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
  end

  def edit
    @article = Article.find_by_id(params[:id])
    @board = @article.board

    @pictures = @article.pictures

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
  end

  def update
    @article = Article.find_by_id(params[:id])

    @article.title = params[:article][:title]
    @article.body = params[:article][:body]
    @article.article_type = params[:article_type]

    if @article.article_type == "앨범"
        # 이미지와 아티클 연결지어주기 
        if !params[:picture].nil?
          pictures = params[:picture]
          pictures.each do |key, value|
            pict = Picture.find_by_id(value)
            pict.update_attribute(:article_id, @article.id)
          end
        end
    end

    if @article.save
      redirect_to article_path(group_id: @article.board.group.id, board_id: @article.board.id, id: params[:id])
    end

  end

  def show

    @article = Article.find_by_id(params[:id])
    @comments = @article.comments
    @comment = Comment.new

    if params[:type] == "click_alarm"
      @alarms = @article.alarms.where("acceptor_id = ?",current_user.id)
      alarm = @alarms.find_by_new(true)
      alarm.update_attribute(:new, false) unless alarm.nil?
    end

    case @article.article_type
    when "일반" # 일반게시물
      render 'show'
    when "소꼬지" # 소꼬지 게시물
      render 'sokkoji_show'
    when "익명" # 익명게시물
      render 'anonymous_show'
    when "앨범" # 앨범게시물
      @images = @article.pictures
      render 'album_show'
    end
  end

  def create
    @board = Board.find_by_id(params[:board_id])

    @article = Article.new(params[:article])
    @article.article_type = params[:article_type]
    @article.date = params[:article][:date].to_datetime unless params[:article][:date].nil? #소꼬지 일정 저장
    @article.board_id = @board.id


    #익명게시물일 경우 유저 아이디를 저장하지 않음.
    if @article.article_type != "익명"
      @article.user_id = session[:user_id]
    else
      @article.set_password(params[:password])
    end

    if @article.save

      #poll 저장
      @poll = Poll.new
      @poll.title = params[:poll_title]
      @poll.article_id = @article.id
      @poll.poll_type = params[:poll_type]
      @poll.save

      unless @poll.nil?
        params[:poll_option].to_a.each do |key,value|
          @option = Option.new
          @option.content = value
          @option.poll_id = @poll.id
          @option.save
        end
      end

      if @article.article_type == "앨범" # 앨범게시물일 경우.
        # 이미지와 아티클 연결지어주기 
        if !params[:picture].nil?
          pictures = params[:picture]
          pictures.each do |key, value|
            pict = Picture.find_by_id(value)
            pict.update_attribute(:article_id, @article.id)
          end
        end
        

      end

      redirect_to articles_path(:group_id => params[:group_id], :board_id => params[:board_id], page: 1)
    else
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

  end

end
