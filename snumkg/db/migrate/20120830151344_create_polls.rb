class CreatePolls < ActiveRecord::Migration
  def change
    create_table :polls do |t|
      t.string :title
      t.integer :article_id
      t.string :poll_type

      t.timestamps
    end
  end
end
