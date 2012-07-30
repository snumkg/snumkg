class BoardsController < ApplicationController
  layout 'main'
  def index
    @boards = Group.find_by_name(params[:group_name]).boards
  end

  def new
  end

  def edit
  end

  def show
  end
end
