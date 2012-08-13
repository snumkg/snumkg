class AlbumImagesController < ApplicationController

  def get_image
    @img = AlbumImage.find_by_id(params[:id])

    send_file(@img.full_path, :type => 'image/jpg', :dispositon => 'inline')

  end

  def destroy
    @img = AlbumImage.find_by_id(params[:id])
    @article = @img.article

    if @img.destroy
      redirect_to edit_article_path(group_id: @article.board.group.id, board_id: @article.board.id, id: @article.id)
    end
  end
end
