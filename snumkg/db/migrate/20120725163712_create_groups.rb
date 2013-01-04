class CreateGroups < ActiveRecord::Migration
  def change
    create_table :groups do |t|
      t.string  :name
      t.integer :admin_id
      t.boolean :is_hidden, :default => false
      t.string  :group_type

      t.timestamps
    end
  end
end
