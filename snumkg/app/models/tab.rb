class Tab < ActiveRecord::Base
   attr_accessible :name, :url_name, :admin_id

   has_many :boards
end
