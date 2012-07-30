class ApplicationController < ActionController::Base

  include AuthHelper

  protect_from_forgery
  before_filter :get_groups
  before_filter :set_group_boards

  def user
    User.find_by_id(session[:user_id])
  end

  def check_signin
    redirect_to signin_path unless signin?
  end

  def check_admin
    redirect_to root_path unless (signin? && current_user.admin?)
  end

  def save_alarm(alarm, acceptor_id, alarm_type, acid ={})
    if acceptor_id != current_user.id
      alarm.acceptor_id = acceptor_id
      alarm.alarmer_id = current_user.id
      alarm.alarm_type = alarm_type
   
      alarm.article_id = acid[:article_id]
      alarm.comment_id = acid[:comment_id]
      alarm.save
      alarm.acceptor.update_attribute(:alarm_counts,alarm.acceptor.alarm_counts + 1)

   ##   new_alarms = alarm.acceptor.alarms[0..(alarm.acceptor.alarm_counts-1)]

   ##   new_alarms.group_by(&:
      # 새로운 알림 숫자를 저장할 때, 같은 것끼리 모아서 보여주기.
      # 엄태건님 외 3명이 글에 댓글을 남겼습니다.

    end
  end

  def destroy_alarm(alarm)
    user = alarm.acceptor

    if user.alarm_counts > 0 
      user.update_attribute(:alarm_counts, user.alarm_counts - 1)
    end
    alarm.destroy unless alarm.nil?
  end



  private
  def get_groups
    @groups = Group.all
  end

  def set_user
  end

  def set_group_boards
    @current_group = Group.find_by_name(params[:group_name])
    @boards = @current_group.boards if @current_group
  end
end
