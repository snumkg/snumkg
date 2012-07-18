class Tab < ActiveRecord::Base
  attr_protected

  validates_uniqueness_of :name

  has_many :boards
end
