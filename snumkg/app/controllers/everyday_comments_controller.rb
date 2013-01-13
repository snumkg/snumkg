class EverydayCommentsController < ApplicationController

  def create
    @comment = Comment.new
    @comment.user_id = params[:everyday_comment][:user_id]
    @comment.article_id = params[:everyday_comment][:article_id]
    @comment.content = params[:everyday_comment][:content]

    if @comment.save
      @post = Article.find_by_id(@comment.article_id)
      @comments = @post.comments
      respond_to do |format|
        format.html {redirect_to everyday_path}
        format.js
      end
    end
  end

  def destroy
    @comment = Comment.find_by_id(params[:id])
    @post = @comment.article

    if current_user == @comment.writer
      if @comment.destroy
        respond_to do |format|
          format.html {redirect_to everyday_path(page: params[:page])}
          format.js
        end
      end
    else
      redirect_to everyday_path(page: params[:page])
    end
  end
end
