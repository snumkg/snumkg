class EverydayPost < ActiveRecord::Base
  attr_accessible :content, :user_id

  belongs_to :user
  has_many :everyday_comments


  def self.new_post?
    if !EverydayPost.where("created_at >= ?", Time.now.yesterday.yesterday).limit(1).empty?
      true
    else
      false
    end
  end
end
