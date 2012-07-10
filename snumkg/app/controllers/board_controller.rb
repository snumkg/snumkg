class BoardController < ApplicationController
  def index
    @board = @boards.find_by_url_name(params[:board_name])
    @articles = @board.articles
  end
end
