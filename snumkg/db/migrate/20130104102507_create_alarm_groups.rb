class CreateAlarmGroups < ActiveRecord::Migration
  def change
    create_table :alarm_groups do |t|
      t.integer :article_id
      t.integer :comment_id
      t.string :alarm_type #like인지, article인지, comment의 like인지 등
      t.integer :accepter_id

      t.boolean :is_new, :default => true

      t.timestamps
    end
  end
end
