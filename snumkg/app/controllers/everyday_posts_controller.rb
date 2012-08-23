class EverydayPostsController < ApplicationController
  layout 'main'

  def index
    @posts = EverydayPost.all(:order => "created_at desc")
    @post = EverydayPost.new
    
  end

  def create
    
  end

  def destroy
    
  end
end
