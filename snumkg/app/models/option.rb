class Option < ActiveRecord::Base
  attr_accessible :content, :count, :vote_id

  belongs_to :vote
end
