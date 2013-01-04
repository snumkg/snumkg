class CreateAlarmGroups < ActiveRecord::Migration
  def change
    create_table :alarm_groups do |t|
      t.integer :article_id
      t.integer :comment_id
      t.integer :everyday_comment_id
      t.integer :everyday_post_id
      t.integer :alarm_type #like인지, article인지, comment의 like인지 등
      t.integer :user_id

      t.boolean :is_new, :default => true

      t.timestamps
    end
  end
end
