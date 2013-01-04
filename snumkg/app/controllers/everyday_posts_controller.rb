class EverydayPostsController < ApplicationController
  before_filter :check_signin
  layout 'main'

  def index
    @board = Board.find_by_type(5)
    @page = params[:page].to_i || 1

    @posts = @board.articles.order("created_at desc").page(@page).per(5)
    @post = Article.new
   
  end

  def create
    @post = Article.new
    @post.user_id = params[:everyday_post][:user_id]
    @post.content = params[:everyday_post][:content]

    if @post.save
      @page = params[:page].to_i || 1
      @posts = Article.where(:article_type => Article.type_i_to_s("매일매일"), :order => "created_at desc").page(@page).per(5)
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
