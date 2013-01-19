#coding: utf-8
class Attendance < ActiveRecord::Base
  include AlarmHelper

  after_create :save_alarm
  before_destroy :destroy_alarm
  
  belongs_to :article
  belongs_to :user

  validates_uniqueness_of :article_id, :scope => [:user_id]

  private
  def save_alarm
    if self.article.writer and self.user and self.article
      save_alarm_helper(accepter_id: self.article.writer.id,
                        alarmer_id: self.user.id,
                        article_id: self.article.id,
                        alarm_type: "참석")
    end
  end

  def destroy_alarm
    if self.article.writer and self.user and self.article
      destroy_alarm_helper(:alarmer_id => self.user.id,
                           :accepter_id => self.article.writer.id,
                           :article_id => self.article.id,
                           :alarm_type => "참석")
    end
  end

end
