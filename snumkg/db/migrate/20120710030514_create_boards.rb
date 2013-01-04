#encoding: utf-8
class CreateBoards < ActiveRecord::Migration
  def change
    create_table :boards do |t|
      t.integer :group_id
      t.string  :name
      t.integer :admin_id
      t.string :board_type, :default => "일반"
      t.boolean :is_hidden, :default => false
      t.integer :position, :default => 0 #게시판 순서


      t.timestamps
    end
  end
end
