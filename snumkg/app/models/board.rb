class Board < ActiveRecord::Base
   attr_accessible :name, :tab_id, :admin_id, :url_name

   has_many :articles
   belongs_to :board
end
