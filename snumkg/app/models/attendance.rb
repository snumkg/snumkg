class Attendance < ActiveRecord::Base
  
  belongs_to :sokkoji_article
  belongs_to :user
end
