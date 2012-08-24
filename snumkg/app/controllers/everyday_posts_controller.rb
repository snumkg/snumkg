class EverydayPostsController < ApplicationController
  before_filter :check_signin
  layout 'main'

  def index
    @posts = EverydayPost.all(:order => "created_at desc")
    @post = EverydayPost.new
    
  end

  def create
    @post = EverydayPost.new
    @post.user_id = params[:everyday_post][:user_id]
    @post.content = params[:everyday_post][:content]

    if @post.save
      redirect_to everyday_path
    end

    
  end

  def destroy
    
  end
end
