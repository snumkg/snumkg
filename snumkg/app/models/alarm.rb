class Alarm < ActiveRecord::Base
  # type
  # 0 : 글을 추천할때
  # 1 : 글에 댓글을 달 때
  # 2 : 댓글을 추천할 때
  # 3 : 프로필에 댓글을 달 때
  # 4 : 소꼬지에 참석할 때
  before_create :alarm_save
  attr_accessible :acceptor_id, :alarm_type, :alarmer_id, :article_id, :comment_id

  belongs_to :alarmer, :class_name => 'User', :foreign_key => :alarmer_id
  belongs_to :acceptor, :class_name => 'User', :foreign_key => :acceptor_id
  belongs_to :article
  belongs_to :comment

  validates_presence_of :acceptor_id, :alarmer_id 

  def alarm_save
    # 알림 그룹에 new 알림이 있을 시에는
    # new => false로 저장.
    
    case self.alarm_type
    when 0, 1, 3, 4
      unless Alarm.where(:alarm_type => self.alarm_type,
                  :article_id => self.article_id,
                  :acceptor_id => self.acceptor_id).find_by_new(true).nil?
        self.new = false
      end
    when 2 
      unless Alarm.where(:alarm_type => self.alarm_type,
                         :comment_id => self.comment_id,
                         :acceptor_id => self.acceptor_id).find_by_new(true).nil?
        self.new = false
      end

    end
    true

  end
end
