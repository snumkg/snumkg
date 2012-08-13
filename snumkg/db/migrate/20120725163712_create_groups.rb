class CreateGroups < ActiveRecord::Migration
  def change
    create_table :groups do |t|
      t.string  :name
      t.integer :admin_id
      t.boolean :hide, :default => false

      t.timestamps
    end
  end
end
