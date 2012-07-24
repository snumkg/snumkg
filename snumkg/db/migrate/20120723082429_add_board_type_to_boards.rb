class AddBoardTypeToBoards < ActiveRecord::Migration
  def change
    add_column :boards, :board_type, :integer, :default => 0
  end
end
