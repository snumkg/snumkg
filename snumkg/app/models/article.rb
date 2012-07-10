class Article < ActiveRecord::Base
  attr_accessible :title, :body, :user_id, :board_id

  belongs_to :board
  belongs_to :user
end
