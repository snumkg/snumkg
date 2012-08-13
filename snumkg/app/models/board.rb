class Board < ActiveRecord::Base
  attr_protected

  # board_type 
  # 0 :일반게시판
  # 1 : 소꼬지게시판
  # 2 : 익명게시판
  # 3 : 앨범게시판
  has_many :articles
  belongs_to :group

  private
end
