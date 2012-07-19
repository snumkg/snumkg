class CommentAlarm < ActiveRecord::Base
  attr_accessible :acceptor, :alarmer_id, :comment_id
end
