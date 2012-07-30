class UnlikesController < ApplicationController

  def article
    @like = Like.where(:article_id => params[:article_id], :user_id => current_user.id).limit(1).first
    @like.destroy unless @like.nil?
  
    redirect_to :back

  end

  def comment
    @like = Like.where(:comment_id => params[:comment_id], :user_id => session[:user_id]).limit(1).first

    @like.destroy unless @like.nil?
    redirect_to :back
    
  end
end
