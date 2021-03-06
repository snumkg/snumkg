class Admin::GroupsController < AdminController
	def index
		@groups = Group.all
	end
  
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
    redirect_to admin_groups_path
  end

  def update
    group = Group.find_by_id(params[:id])

    group.update_attributes(params[:group])
    redirect_to admin_groups_path
  end

  def edit
    @group = Group.find_by_id(params[:id])
  end

  def hide
    @group = Group.find_by_id(params[:id])

    if params[:hide] == "false"
      @group.update_attribute(:is_hidden, false)
    else
      @group.update_attribute(:is_hidden, true)
    end
    redirect_to admin_groups_path
  end

  def destroy
    @group = Group.find_by_id(params[:id])

    @group.destroy
    redirect_to admin_groups_path
  end

  def set_positions
    @positions = params[:positions].to_a
    @positions.each_with_index do |board_id, i|
      board = Board.find(board_id)
      board.position = i
      board.save
    end

    render :json => {message: "success"}
  end
end
