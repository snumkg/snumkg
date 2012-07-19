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


  def save_alarm(alarm, acceptor_id, alarm_type, article_id)
    if acceptor_id != current_user.id
      alarm.acceptor_id = acceptor_id
      alarm.alarmer_id = current_user.id
      alarm.alarm_type = alarm_type
      alarm.article_id = article_id
      alarm.save
    end
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
