class Attendance < ActiveRecord::Base
  include AlarmHelper

  before_create :save_alarm
  before_destroy :destroy_alarm
  
  belongs_to :article
  belongs_to :user

  validates_uniqueness_of :article_id, :scope => [:user_id]

  private
  def save_alarm
    save_alarm_helper(acceptor_id: self.article.writer.id,
                      alarmer_id: self.user.id,
                      article_id: self.article.id,
                      alarm_type: 4)
  end

  def destroy_alarm
    destroy_alarm_helper(:alarmer_id => self.user.id,
                   :article_id => self.article.id,
                   :alarm_type => 4)
  end

end
