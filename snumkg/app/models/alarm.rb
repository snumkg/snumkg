class Alarm < ActiveRecord::Base
  attr_accessible :acceptor_id, :alarm_type, :alarmer_id, :article_id, :comment_id

  belongs_to :alarmer, :class_name => 'User', :foreign_key => :alarmer_id
  belongs_to :acceptor, :class_name => 'User', :foreign_key => :acceptor_id
  belongs_to :article
  belongs_to :comment
  belongs_to :sokkoji_article
end
