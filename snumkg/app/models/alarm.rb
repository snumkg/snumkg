#coding: utf-8
class Alarm < ActiveRecord::Base
  attr_protected
  validates_presence_of :alarmer_id 

=begin
  before_create :alarm_save

  def alarm_save
    # 알림 그룹에 new 알림이 있을 시에는
    # new => false로 저장.
    
    case self.alarm_type
    when 0, 1, 3, 4
      unless Alarm.where(:alarm_type => self.alarm_type,
                  :article_id => self.article_id,
                  :acceptor_id => self.acceptor_id).find_by_is_new(true).nil?
        self.is_new = false
      end
    when 2 
      unless Alarm.where(:alarm_type => self.alarm_type,
                         :comment_id => self.comment_id,
                         :acceptor_id => self.acceptor_id).find_by_is_new(true).nil?
        self.is_new = false
      end
    when 5
      unless Alarm.where(:alarm_type => self.alarm_type,
                         :everyday_post_id => self.everyday_post_id,
                         :acceptor_id => self.acceptor_id).find_by_is_new(true).nil?
        self.is_new = false
      end
    end
    true

  end
=end
end
