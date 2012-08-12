class BoardsController < ApplicationController
  layout 'main'
  def index
    @boards = Group.find_by_id(params[:group_id]).boards
  end

  def new
  end

  def edit
  end

  def show
  end
end
