#coding: utf-8
class Alarm < ActiveRecord::Base
  attr_protected
  validates_presence_of :alarmer_id 

  belongs_to :alarm_group
  after_destroy :destroy_alarm 
  before_save :save_alarm

  def save_alarm
    Alarm.where(alarmer_id: self.alarmer_id, alarm_group_id: self.alarm_group_id).delete_all
  end

  def destroy_alarm
    #AlarmGroup의 size가 0이면 AlarmGroup 삭제
    if self.alarm_group.alarms.size == 0 then
      self.alarm_group.destroy
    end
  end
end
