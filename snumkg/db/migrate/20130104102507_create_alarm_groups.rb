class CreateAlarmGroups < ActiveRecord::Migration
  def change
    create_table :alarm_groups do |t|
      t.integer :article_id
      t.integer :comment_id
      t.string :alarm_type #like인지, article인지, comment의 like인지 등
      t.integer :accepter_id

      t.integer :state, :default => 0 #처음 0, 지구본 클릭시 1, 클릭해서 게시물 확인 시 2
      t.datetime :refreshed_at

      t.timestamps
    end
  end
end
