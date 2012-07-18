#encoding: utf-8
class LikeCommentsController < ApplicationController
  
  def like
    @like = LikeComment.new
    @like.comment_id = params[:comment_id]
    @like.user_id = current_user.id unless current_user.nil?

    if @like.save
      redirect_to :back
    else
      flash[:error] = "잘못된 접근입니다."
      redirect_to root_path
    end
  end

  def unlike
    @like = LikeComment.where(:comment_id => params[:comment_id], :user_id => session[:user_id]).limit(1).first

    @like.destroy unless @like.nil?
    redirect_to :back
    
  end
end
