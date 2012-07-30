class CreateAlarms < ActiveRecord::Migration
  def change
    create_table :alarms do |t|
      t.integer :article_id
      t.integer :comment_id
      t.integer :acceptor_id
      t.integer :alarmer_id
      t.integer :alarm_type
      t.boolean :new, :default => true

      t.timestamps
    end
  end
end
