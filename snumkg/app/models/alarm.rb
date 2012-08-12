class Alarm < ActiveRecord::Base
  # type
  # 0 : 글을 추천할때
  # 1 : 글에 댓글을 달 때
  # 2 : 댓글을 추천할 때
  # 3 : 프로필에 댓글을 달 때
  # 4 : 소꼬지에 참석할 때
  attr_accessible :acceptor_id, :alarm_type, :alarmer_id, :article_id, :comment_id

  belongs_to :alarmer, :class_name => 'User', :foreign_key => :alarmer_id
  belongs_to :acceptor, :class_name => 'User', :foreign_key => :acceptor_id
  belongs_to :article
  belongs_to :comment

  validates_presence_of :acceptor_id, :alarmer_id 
end
