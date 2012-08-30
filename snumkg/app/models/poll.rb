class Poll < ActiveRecord::Base
  attr_accessible :title

  has_many :votes
  has_many :users, :through => :votes
  has_many :options
  belongs_to :article
end
