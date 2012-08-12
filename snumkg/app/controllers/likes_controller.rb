#encoding: utf-8
class LikesController < ApplicationController


  def article
    @like = Like.new
    @like.article_id = params[:article_id]
    @like.user_id = current_user.id unless current_user.nil?

=begin
    if !@like.errors.any?
      @result = @like.article.likes.map{|like| like.user.nickname}
      #글을 추천받았을 경우 알람 발생!! 
      @article = Article.find_by_id(params[:article_id])
      save_alarm(Alarm.new, @article.writer.id, 0, :article_id => params[:article_id])
      @like.save

    else
      @result = {error: "이미 추천하셨습니다."}
    end
=end
    if @like.errors.any?
      @result = {error: "이미 추천하셨습니다."}
    else
      @like.save
    end

    respond_to do |format|
      format.json {render :json => @result}
      format.html {redirect_to article_path(group_id: @like.article.board.group.id, board_id: @like.article.board.id, id: @like.article.id)}
    end
   
  end

  def comment
    @like = Like.new
    @like.comment_id = params[:comment_id]
    @like.user_id = current_user.id unless current_user.nil?
=begin
    @comment = Comment.find_by_id(params[:comment_id])
    save_alarm(Alarm.new, @comment.writer.id, 2, :article_id => @comment.article.id, :comment_id => params[:comment_id])
=end
    if @like.save
      redirect_to article_path(group_id: @like.comment.article.board.group.id, board_id: @like.comment.article.board.id, id: @like.comment.article.id)
    else
      flash[:error] = "잘못된 접근입니다."
      redirect_to root_path
    end
    
  end
end
