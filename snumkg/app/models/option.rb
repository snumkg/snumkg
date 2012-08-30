class Option < ActiveRecord::Base
  attr_accessible :content, :count, :vote_id

  belongs_to :poll
  has_many :votes
end
