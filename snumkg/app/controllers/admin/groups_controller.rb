class Admin::GroupsController < AdminController
  
  def show
    @group = Group.find_by_id(params[:id])
    @boards = @group.boards
  end

  def new
    @group = Group.new
  end

  def create
    @group = Group.new(params[:group])

    @group.save
    redirect_to admin_path
  end

  def update
    group = Group.find_by_id(params[:id])

    group.update_attributes(params[:group])
    redirect_to admin_path
  end

  def edit
    @group = Group.find_by_id(params[:id])
  end

  def destroy
    @group = Group.find_by_id(params[:id])

    @group.destroy
    redirect_to admin_path
  end
end
