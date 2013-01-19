#encoding: utf-8
class Article < ActiveRecord::Base
  attr_protected

  before_save :setting_default
	before_create :set_number #글번호 부여
  after_create :set_newsfeed

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
  # 일반 게시물
  # 소꼬지 게시물
  # 익명 게시물
  # 앨범 게시물
  # 매일매일 게시물
  
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

  # 글쓴이의 닉네임 리턴
  def nickname
    if self.writer then
      self.writer.nickname
    else
      self.anonymous_name
    end
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

	def set_number
		#글번호 부여
		board = self.board
		if board then
			self.number = board.article_count
			board.article_count = board.article_count + 1
			board.save
		end
	end

  def set_newsfeed
    news = Newsfeed.new
    news.article_id = self.id
    news.save
  end


  def setting_default
    def is_valid?(str)
      not(str.nil? || str.empty? || str.blank?)
    end

    # 글 제목이 없을 경우 제목없음으로 넣어줌
    unless is_valid?(self.title)
      self.title = "제목없음"
    end

    # 아티클 타입은 board 타입과 항상 같게 저장
    self.article_type = Board.find_by_id(self.board_id).board_type

    # validator
    if self.article_type != '익명' and self.user_id.nil? then
      return false
    end
  end

end
