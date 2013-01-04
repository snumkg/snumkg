#encoding: utf-8
class Article < ActiveRecord::Base
  attr_protected
  validates_presence_of :user_id, :unless => Proc.new {|article| article.article_type == "익명"}
  validates_presence_of :board_id

  belongs_to :board
  belongs_to :writer, :class_name => 'User', :foreign_key => :user_id

  has_many :comments, :dependent => :destroy
  has_many :likes, :dependent => :destroy
  has_many :attendances, :dependent => :destroy
  has_one :poll
  #has_many :album_images, :dependent => :destroy
  has_many :alarms, :class_name => 'Alarm', :foreign_key => :article_id
  has_many :pictures, :dependent => :destroy

  # type
  # 0: 일반 게시물
  # 1: 소꼬지 게시물
  # 2: 익명 게시물
  # 3: 앨범 게시물
  # 4: 매일매일 게시물
  
  def type_text
    case self.article_type
    when 0
      "일반"
    when 1
      "소꼬지"
    when 2
      "익명"
    when 3
      "앨범"
    when 4
      "매일매일"
    end
  end

  def type_s_to_i(str)
    case str
    when "일반"
      0
    when "소꼬지"
      1
    when "익명"
      2
    when "앨범"
      3
    when "매일매일"
      4
    end
  end

  def type_i_to_s(i)
    case i
    when 0
      "일반"
    when 1
      "소꼬지"
    when 2
      "익명"
    when 3
      "앨범"
    when 4
      "매일매일"
    end
  end

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

	#지금 기준으로 언제 쓰여졌는지 리턴
  def relative_time
  	diff = (Time.now - self.created_at).to_i
  	
  	if diff < 60
  		"방금 전"
		elsif diff < 3600
			"#{diff/60}분 전"
		elsif diff < 86400
			"#{diff/3600}시간 전"
		elsif diff < 86400 * 4
			"#{diff/86400}일 전"
		else
			self.created_at.strftime("%m-%d")
		end
	end

end
