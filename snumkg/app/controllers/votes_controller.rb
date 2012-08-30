class VotesController < ApplicationController
  layout 'default'

  def create
    @option = Option.find_by_id(params[:option])
    @poll = @option.poll

    @vote = Vote.new
    @vote.poll_id = @poll.id
    @vote.user_id = current_user.id
    @vote.option_id = @option.id

    @article = @poll.article

    if @vote.save
      redirect_to article_path(group_id: @article.board.group.id, board_id: @article.board.id, id: @article)
    end

  end
end
