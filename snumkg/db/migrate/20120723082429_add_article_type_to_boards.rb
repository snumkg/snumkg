class AddArticleTypeToBoards < ActiveRecord::Migration
  def change
    add_column :boards, :article_type, :integer, :default => 0
  end
end
