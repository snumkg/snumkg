class User < ActiveRecord::Base
  attr_accessor :password, :password_confirmation
  attr_protected :level, :password_salt, :password_hash

  validates_presence_of :username, :password, :password_confirmation, :nickname
  validates_uniqueness_of :username
  validates_confirmation_of :password
  #validates_format_of :email, :with => /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i
  validates_length_of :password, :minimum => 4
  
  has_many :articles
  has_many :comments
  has_many :like_articles

  def self.authentication(username, password)
    user = User.find_by_username(username)
    if user.blank? || Digest::SHA256.hexdigest(password + user.password_salt) != user.password_hash
      user = nil
    end
    user
  end

  def set_password(pass)
    salt = [Array.new(6){rand(256).chr}.join].pack("m").chomp
    self.password_salt, self.password_hash = salt, Digest::SHA256.hexdigest(pass.to_s + salt)
  end

end
