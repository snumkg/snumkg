class User < ActiveRecord::Base
  attr_accessible :username, :email, :phone_number, :department

  has_many :articles
end
