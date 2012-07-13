class Board < ActiveRecord::Base
  attr_protected

  validates_uniqueness_of :url_name

  has_many :articles
  belongs_to :board
end
