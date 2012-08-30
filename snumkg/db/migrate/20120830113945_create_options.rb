class CreateOptions < ActiveRecord::Migration
  def change
    create_table :options do |t|
      t.string :content
      t.integer :vote_id
      t.integer :count

      t.timestamps
    end
  end
end
