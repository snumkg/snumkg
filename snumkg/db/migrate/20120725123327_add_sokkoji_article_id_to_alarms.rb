class AddSokkojiArticleIdToAlarms < ActiveRecord::Migration
  def change
    add_column :alarms, :sokkoji_article_id, :integer
  end
end
