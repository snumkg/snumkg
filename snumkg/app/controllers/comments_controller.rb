class CommentsController < ApplicationController
  def create

    tab_name = params[:comment][:tab_name]
    board_name = params[:comment][:board_name]

    @comment = Comment.new
    @comment.content = params[:comment][:content]
    @comment.article_id = params[:comment][:article_id]
    @comment.user_id = params[:comment][:user_id]

    if @comment.save
      redirect_to article_path(tab_name: tab_name, board_name: board_name, id: params[:comment][:article_id])
 
    else
      redirect_to article_path(tab_name: tab_name, board_name: board_name, id: params[:comment][:article_id])  
    end
  end

  def destroy
    comment = Comment.find_by_id(params[:id])

    if comment.destroy
      redirect_to :back
    else

    end
    
  end
end
