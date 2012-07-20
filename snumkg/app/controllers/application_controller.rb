class ApplicationController < ActionController::Base

  include AuthHelper

  protect_from_forgery
  before_filter :get_tabs
  before_filter :set_tab_boards

  def user
    User.find_by_id(session[:user_id])
  end

  def check_signin
    redirect_to signin_path unless signin?
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
  def get_tabs
    @tabs = Tab.all
  end

  def set_user
  end

  def set_tab_boards
    @current_tab = Tab.find_by_name(params[:tab_name])
    @boards = @current_tab.boards if @current_tab
  end
end
