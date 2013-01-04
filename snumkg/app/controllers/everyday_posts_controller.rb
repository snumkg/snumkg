#encoding: utf-8
class EverydayPostsController < ApplicationController
  before_filter :check_signin
  layout 'main'

  def index
    @board = Board.find_by_board_type("매일매일")
    @page = params[:page].to_i || 1

    @posts = @board.articles.order("created_at desc").page(@page).per(5)
    @post = Article.new
  end

  def create
    @post = Article.new
    @post.user_id = params[:everyday_post][:user_id]
    @post.body = params[:everyday_post][:body]
    @post.board_id = params[:everyday_post][:board_id]

    if @post.save
      @page = params[:page].to_i || 1
      @posts = @post.board.articles.order("created_at desc").page(1).per(5)
      @post = Article.new      
      
      respond_to do |format|
        format.html {redirect_to everyday_path}
        format.js
      end
    end
  end

  def destroy
    
  end
end
