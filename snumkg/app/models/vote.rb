class Vote < ActiveRecord::Base
  attr_accessible :article_id, :title

  belongs_to :article
  has_many  :options
end
