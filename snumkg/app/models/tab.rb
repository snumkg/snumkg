class Tab < ActiveRecord::Base
  attr_protected

  validates_uniqueness_of :url_name

  has_many :boards
end
