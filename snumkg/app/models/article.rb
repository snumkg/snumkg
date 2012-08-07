class Article < ActiveRecord::Base
  attr_protected
  validates_presence_of :user_id, :unless => Proc.new {|article| article.article_type == 2}
  validates_presence_of :board_id

  belongs_to :board
  belongs_to :writer, :class_name => 'User', :foreign_key => :user_id

  has_many :comments, :dependent => :destroy
  has_many :likes, :dependent => :destroy
  has_many :attendances, :dependent => :destroy
  has_many :album_images, :dependent => :destroy

  def liked_by?(user_id)
    !Like.where(:article_id => self.id, :user_id => user_id).limit(1).first.nil?
  end

  def liked_by_users
    Like.where(:article_id => self.id).map {|like| like.user}
  end

  def attendanced_by?(user)
    !Attendance.where(:article_id => self.id, :user_id => user.id).limit(1).first.nil?
  end


  def authentication(password)
    if Digest::SHA256.hexdigest(password + self.password_salt) != self.password_hash
      false
    else
      true
    end
  end

  def set_password(pass)
    salt = [Array.new(6){rand(256).chr}.join].pack("m").chomp
    self.password_salt, self.password_hash = salt, Digest::SHA256.hexdigest(pass.to_s + salt)
  end

end
