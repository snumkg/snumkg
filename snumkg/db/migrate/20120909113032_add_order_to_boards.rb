class AddOrderToBoards < ActiveRecord::Migration
  def change
    add_column :boards, :board_order, :integer, :default => 0
  end
end
