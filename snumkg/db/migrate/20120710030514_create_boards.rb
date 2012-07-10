class CreateBoards < ActiveRecord::Migration
  def change
    create_table :boards do |t|
      t.integer :tab_id
      t.string  :name
      t.integer :admin_id


      t.timestamps
    end
  end
end
