#encoding: utf-8
class CommentsController < ApplicationController

  def create
    #게시물에 코멘트가 달렸을 때
    article = Article.find_by_id(params[:comment][:article_id])
    @comment = Comment.new
    @comment.content = params[:comment][:content]
    @comment.article_id = params[:comment][:article_id]

    if article.article_type != "익명" # 익명게시판이 아닐때
      @comment.user_id = params[:comment][:user_id]
    else #익명게시판일때
      @comment.set_password(params[:comment][:password])
      @comment.username= params[:comment][:username]
    end

    if @comment.save
      respond_to do |format|
        format.html {redirect_to article_path(group_id: article.board.group.id, board_id: article.board.id, id: params[:comment][:article_id])}
        format.js {
        }
      end
    else
      flash[:error] = "comment error"
      redirect_to article_path(group_id: article.board.group.id, board_id: article.board.id, id: params[:comment][:article_id])
    end
  end

  def destroy
    comment = Comment.find_by_id(params[:id])
    if comment.profile_user_id.nil? # 게시물 댓글일때
      group_id = comment.article.board.group.id
      board_id = comment.article.board.id
      article_id = comment.article.id

      if comment.article.article_type == "익명" && !comment.authentication(params[:password])
        # 익명 댓글일 때 비밀번호가 일치하지 않을 시
        flash[:error] = "비밀번호가 일치하지 않습니다."
        redirect_to article_path(group_id: group_id, board_id: board_id, id: article_id)
        return
      end
      comment.destroy
      redirect_to article_path(group_id: group_id, board_id: board_id, id: article_id)
    else #프로필 댓글일 때
      pid = comment.profile_user_id
      comment.destroy
      redirect_to profile_path(pid)
    end
  end

  def create_profile_comment
    @profile_comment = Comment.new
    @profile_comment.profile_user_id = params[:profile_user_id]
    @profile_comment.user_id = current_user.id unless current_user.nil?
    @profile_comment.content = params[:content]

    @profile_comment.save

    redirect_to profile_path(params[:profile_user_id])
   
  end

  def destroy_profile_comment
    comment = Comment.find_by_id(params[:id])
    profile_user_id = comment.profile_user_id

    if comment.destroy
      redirect_to profile_path(profile_user_id)
    else
      redirect_to root_path
    end
  end
end
