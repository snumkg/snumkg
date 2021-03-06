#encoding: utf-8
class Admin::BoardsController < AdminController
  layout false
  
  def new
    @board = Board.new 
    @select_groups = Group.all
    @select_groups.map! {|g| [g.name, g.id]}
  end

  def create
    @board = Board.new(params[:board])

    @board.save
    redirect_to admin_path
    
  end

  def edit
    @board = Board.find_by_id(params[:id])
    @select_groups = Group.all
    @select_groups.map! {|g| [g.name, g.id]}
  end

  def update
    @board = Board.find_by_id(params[:id])

    if @board.update_attributes(params[:board])
      flash[:success] = "#{@board.name}이 성공적으로 변경되었습니다.."
      redirect_to admin_group_path(@board.group)
    else
      flash[:error] = "게시판 수정 실패"
      redirect_to admin_group_path(@board.group)
    end
   
  end

  def hide
    @board = Board.find_by_id(params[:id])

    if params[:hide] == "false"
      @board.update_attribute(:is_hidden, false)
    else
      @board.update_attribute(:is_hidden, true)
    end
    redirect_to admin_path
  end

  def destroy
   
    @board = Board.find_by_id(params[:id])

    if can_destroy?(@board)
      @board.destroy
      flash[:success] = "게시판이 성공적으로 삭제되었습니다."
      redirect_to admin_path
    else
      flash[:error] = "게시판을 삭제할 수 없습니다."
      redirect_to admin_path
    end
  end

  def can_destroy?(board)
    if board.articles.empty? 
      true
    else
      false
    end
  end
end
