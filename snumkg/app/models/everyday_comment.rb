#coding: utf-8
class EverydayComment < ActiveRecord::Base
  include AlarmHelper

  after_create :save_alarm
  before_destroy :destroy_alarm

  attr_accessible :content, :user_id

  belongs_to :everyday_post
  belongs_to :user
  has_one :alarm, :class_name => "Alarm", :foreign_key => "everyday_comment_id"

  validates_presence_of :content
  validates_presence_of :user_id, :everyday_post_id


  private
  def save_alarm
    save_alarm_helper(acceptor_id: self.everyday_post.user.id,
                      everyday_comment_id: self.id,
                      alarmer_id: self.user.id,
                      alarm_type: 5)
  end

  def destroy_alarm
    self.alarm.destroy
  end
end
