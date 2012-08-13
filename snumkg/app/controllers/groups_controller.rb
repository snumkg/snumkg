#encoding: utf-8
class GroupsController < ApplicationController


  def index
    @groups = Group.all
  end

  def new
   @group = Group.new 
    
  end

  def show
    @group = Group.find_by_id(params[:id])
    @boards = @group.boards.where(:hide => false)
  end

  def create
    @group = Group.new(params[:group])

    if @group.save
      flash[:success] = "그룹이 성공적으로 만들어졌습니다." 
      redirect_to groups_path
    else
      flash[:error] = "그룹만들기 실패"
      redirect_to groups_path
    end
  end

  def edit
    @group = Group.find(params[:id])
  end

  def update
    
  end

  def destroy
    @group = Group.find(params[:id])

    if @group.destroy
      flash[:success] = "그룹이 삭제되었습니다."
    else
      flash[:error] = "그룹 삭제 에러"
    end
    redirect_to groups_path

    
  end
end
