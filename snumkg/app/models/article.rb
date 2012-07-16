class Article < ActiveRecord::Base
  attr_protected
  validates_presence_of :user_id, :board_id

  belongs_to :board
  belongs_to :user

  has_many :comments
end
