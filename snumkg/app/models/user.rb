class User < ActiveRecord::Base
  attr_accessor :password, :password_confirmation
  attr_protected :level, :password_salt, :password_hash

  validates_presence_of :username, :password, :password_confirmation, :nickname
  validates_uniqueness_of :username

  validates_confirmation_of :password

  validates_length_of :password, :minimum => 4 #TODO 6으로 바꿀것!
  validates_length_of :username, :minimum => 4 #TODO 6으로 바꿀것!

  
  validates_format_of :username, :with => /^[a-zA-Z](\d|\w)*/
  #validates_format_of :phone_number, :with => /01\d-(\d{4}|\d{3})-\d{4}/, :allow_blank => true
  validates_format_of :email, :with => /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i, :allow_blank => true
  
  has_many :articles
  has_many :comments
  has_many :send_messages, :class_name => 'Message', :foreign_key => 'sender_id'
  has_many :receive_messages, :class_name => 'Message', :foreign_key => 'receiver_id'
  has_many :alarm_groups, :class_name => 'AlarmGroup', :foreign_key => 'accepter_id'

  #설문조사
  has_many :votes
  has_many :polls, :through => :votes

  def self.authentication(username, password)
    user = User.find_by_username(username)
    if user.blank? || Digest::SHA256.hexdigest(password + user.password_salt) != user.password_hash
      user = nil
    end
    user
  end

  def new_alarm
    alarms = self.alarms
    count = 0
    for alarm in alarms
      if alarm.new?
        count = count + 1
      end
    end
    count
  end

  def set_password(pass)
    salt = [Array.new(6){rand(256).chr}.join].pack("m").chomp
    self.password_salt, self.password_hash = salt, Digest::SHA256.hexdigest(pass.to_s + salt)
  end

  def message_count
    self.receive_messages.where(:is_read => false).count
  end

  def new_alarm_count
    AlarmGroup.where(accepter_id: self.id, state: 0).count
  end

  def profile_image_url
    "/profile_image/#{self.id}"
  end

  def profile_image_thumb_url
    "/profile_image_thumb/#{self.id}"
  end

 end
