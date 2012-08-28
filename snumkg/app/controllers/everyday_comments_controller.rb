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
end
