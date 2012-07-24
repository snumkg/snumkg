class AddDayToSokkojiArticles < ActiveRecord::Migration
  def change
    add_column :sokkoji_articles, :day, :string
  end
end
