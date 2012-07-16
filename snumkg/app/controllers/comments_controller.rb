class CommentsController < ApplicationController
  def create

    @comment = Comment.new
    @comment.content = params[:comment][:content]
    @comment.article_id = params[:comment][:article_id]
    @comment.user_id = params[:comment][:user_id]

    if @comment.save
      redirect_to article_path(tab_name: params[:tab_name], board_name: params[:board_name], id: params[:comment][:article_id])
 
    else
      redirect_to article_path(tab_name: params[:tab_name], board_name: params[:board_name], id: params[:comment][:article_id])
    end
  end
end
