class EverydayCommentsController < ApplicationController

  def create
    @comment = EverydayComment.new(params[:everyday_comment])

    if @comment.save

      respond_to do |format|
        format.html {redirect_to everyday_path}
        format.js
      end
    end
  end

  def destroy
    @comment = EverydayComment.find_by_id(params[:id])

    if current_user == @comment.user
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
