class CreateBoards < ActiveRecord::Migration
  def change
    create_table :boards do |t|
      t.integer :group_id
      t.string  :name
      t.integer :admin_id
      t.integer :board_type, :default => 0


      t.timestamps
    end
  end
end
