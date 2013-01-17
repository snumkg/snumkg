class Newsfeed < ActiveRecord::Base
  has_one :article
  has_one :comment

end
