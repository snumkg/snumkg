class ArticleAlarm < ActiveRecord::Base
  attr_accessible :acceptor_id, :alarmer_id, :article_id

  belongs_to :alarmer, :class_name => "User", :foreign_key => "alarmer_id"
  belongs_to :acceptor, :class_name => "User", :foreign_key => "acceptor_id"
  belongs_to :article


end
