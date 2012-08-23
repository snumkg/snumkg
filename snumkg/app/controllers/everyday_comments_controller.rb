class EverydayCommentsController < ApplicationController

  def create
    @comment = EverydayComment.new(params[:everyday_comment])

    if @comment.save
      redirect_to everyday_path
    end
  end
end
