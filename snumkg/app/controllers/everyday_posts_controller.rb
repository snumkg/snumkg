class EverydayPostsController < ApplicationController
  before_filter :check_signin
  layout 'main'

  def index
    @posts = EverydayPost.all(:order => "created_at desc")
    @post = EverydayPost.new
    
    # Pagination
    pagination(@posts, 5)
  end

  def create
    @post = EverydayPost.new
    @post.user_id = params[:everyday_post][:user_id]
    @post.content = params[:everyday_post][:content]

    if @post.save
      @posts = EverydayPost.all(:order => "created_at desc")
      respond_to do |format|
        format.html {redirect_to everyday_path}
        format.js
      end
    end
  end

  def destroy
    
  end
end
