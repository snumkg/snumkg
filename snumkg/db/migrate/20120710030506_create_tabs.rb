class CreateTabs < ActiveRecord::Migration
  def change
    create_table :tabs do |t|
      t.string  :name
      t.string :url_name
      t.integer :admin_id

      t.timestamps
    end
  end
end
