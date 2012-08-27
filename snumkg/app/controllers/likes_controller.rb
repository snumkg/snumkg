#encoding: utf-8
class LikesController < ApplicationController


  def create
    case params[:type]
    when "article"
      @like = Like.new
      @article = Article.find_by_id(params[:id])
      @like.article_id = params[:id]
      @like.user_id = current_user.id unless current_user.nil?

      if @like.errors.any?
        @result = {error: "이미 추천하셨습니다."}
      else
        @like.save
      end

      respond_to do |format|
        #format.json {render :json => @result}
        #format.html {redirect_to article_path(group_id: @like.article.board.group.id, board_id: @like.article.board.id, id: @like.article.id)}
        format.js
      end
    when "comment"
      @like = Like.new
      @like.comment_id = params[:id]
      @like.user_id = current_user.id unless current_user.nil?
      @comment = Comment.find_by_id(params[:id])
=begin
    @comment = Comment.find_by_id(params[:comment_id])
    save_alarm(Alarm.new, @comment.writer.id, 2, :article_id => @comment.article.id, :comment_id => params[:comment_id])
=end
      if @like.save
        respond_to do |format|
          format.html {redirect_to article_path(group_id: @like.comment.article.board.group.id, board_id: @like.comment.article.board.id, id: @like.comment.article.id)}
          format.js 
        end
      else
        flash[:error] = "잘못된 접근입니다."
        redirect_to root_path
      end
    end
  end

  def destroy
    case params[:type]
    when "article"
      @article = Article.find_by_id(params[:id])
      @like = Like.where(:article_id => params[:id], :user_id => current_user.id).limit(1).first
    when "comment"
      @like = Like.where(:comment_id => params[:id], :user_id => session[:user_id]).limit(1).first
      @comment = Comment.find_by_id(params[:id])
    end

    @like.destroy unless @like.nil?

    respond_to do |format|
      format.js 
    end
  end
end
