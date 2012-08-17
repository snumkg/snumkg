#encoding: utf-8
class UsersController < ApplicationController
  before_filter :check_signin, :except => [:create, :new ]
  layout 'main', :except => [:new, :create]
  layout 'default', :only => [:new, :create]
  def index
  end

  def new

    @user = User.new
  end

  def create
    @user = User.new(params[:user])
    phone_number = params[:phone_number_1] + "-" + params[:phone_number_2] + "-" + params[:phone_number_3]
    @user.phone_number = phone_number
    @user.set_password(@user.password)

    if @user.save
      session[:user_id] = @user.id
      redirect_to root_path
    else
      flash[:error] = "회원가입 할 수 없습니다. 회원정보를 다시 입력해주세요."
      redirect_to :back
    end
  end

  def show
    @user = User.find(params[:id])

    @profile_comments = Comment.where(:profile_user_id => params[:id], :comment_type => 1)
    @profile_comment = Comment.new

  end

  def alarms
    render :layout => 'main'
    # Hash 배열을 리턴함
    def select_alarm(type)
      case type
      when 0, 1, 3, 4 
        # 내 글이 추천받을 때
        # 글에 댓글이 달렸을때
        # 내 프로필에 댓글이 달릴 때
        # 소꼬지 게시글에 참석한다고 할때
        Alarm.where(:alarm_type => type, :acceptor_id => current_user.id)
              .order("CREATED_AT DESC")
              .group_by(&:article_id)
              .map {|article_id,alarms| alarms.group_by(&:new)}

      when 2
        # 내 댓글이 추천받을 때
        Alarm.where(:alarm_type => type, :acceptor_id => current_user.id)
              .order("CREATED_AT DESC")
              .group_by(&:comment_id)
              .map {|a,alarms| alarms.group_by(&:new)}
      end
    end

    def push_new_old_alarms(alarmss, new_alarms, old_alarms)
      alarmss.each do |alarms|
        if !alarms[true].nil?
          new_alarms.push alarms
        else
          old_alarms.push alarms
        end
      end
    end

    @new_alarms = Array.new
    @old_alarms = Array.new
    # 여러명이 같은 글에 추천했을 때, 
    # 알람을 모아서 보여주자.
    types = [0, 1, 2, 3, 4]
    types.each do |type|
      push_new_old_alarms(select_alarm(type), @new_alarms, @old_alarms)
    end

    # new_alarms는 hash 배열. 
    # new 값이 true를 가진 값들은 new_alarms에 삽입됨
    # hash key: true/false, value: 알람 배열
    @new_alarms.map! do |alarms|
      for alarm in alarms[true]
        alarm.update_attribute(:new, false) # new컬럼 값 false로 변경
      end
      unless alarms[false].nil?
        (alarms[true] + alarms[false] ).uniq {|alarm| alarm.alarmer}
      else
        alarms[true].uniq {|alarm| alarm.alarmer}
      end
    end

    @old_alarms.map! do |alarms|
      alarms[false].uniq {|alarm| alarm.alarmer}
    end

    #old_alarms 최근 순서대로 정렬
    @old_alarms.sort! do |a,b|
      a[0].created_at < b[0].created_at ? 1 : -1
    end
    session[:alarm_counts] = current_user.alarm_counts # 새로운 알림이 오면 배경색을 바꿔주기 위해 세선에 정보를 저장헤둠
    current_user.update_attribute(:alarm_counts, 0)

  end

  def edit
    @user = current_user
  end

  def update
    raise
  end

  def destroy
  end 


end
