class Board < ActiveRecord::Base
  attr_protected

  #validates_uniqueness_of :url_name  // it is required just for tab_url_name

  has_many :articles
  belongs_to :tab
end
