#encoding: utf-8
class ApplicationController < ActionController::Base

  include AuthHelper

  protect_from_forgery
  before_filter :get_groups
  before_filter :set_group_boards

  def user
    User.find_by_id(session[:user_id])
  end

  def check_signin
    unless signin?
      flash[:error] = "로그인이 필요한 서비스입니다."
      redirect_to root_path 
    end
  end

  def check_admin
    unless signin? && current_user.admin?
      flash[:error] = "관리자만 접근할 수 있습니다."
      redirect_to root_path
    end
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

  def pagination(articles, articles_in_page)
    articles_in_page = 5 # 한 페이지에 보여주는 아티클 수
    @pages = articles.count%articles_in_page == 0 ? (articles.count/articles_in_page) : (articles.count/articles_in_page + 1)
    remains = articles.count%articles_in_page
    @start_page = params[:page].to_i%5 == 0 ? ((params[:page].to_i/5)-1)*5 + 1 : (params[:page].to_i/5)*5 + 1
    @end_page = @start_page + 4 < @pages ? @start_page + 4 : @pages

    if params[:page]
      @articles = articles[((params[:page].to_i-1)*articles_in_page)..((params[:page].to_i)*articles_in_page - 1)]
    else
      @articles = articles[0..9]
    end
  end



  private
  def get_groups
    @groups = Group.where(:hide => false)
    @hakbun_group = Group.where(:group_type => "학번")
    @new_user = User.new
    @anyone_group = Group.find(1)
    @sokkoji_group = Group.find_by_group_type("소꼬지")

  end

  def set_user
  end

  def set_group_boards
    @current_group = Group.find_by_id(params[:group_id])
    @boards = @current_group.boards.where(:hide => false) if @current_group
  end
end
