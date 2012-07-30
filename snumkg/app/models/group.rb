class Group < ActiveRecord::Base
  # attr_accessible :title, :body
  attr_protected

  validates_uniqueness_of :name
  has_many :boards


end
