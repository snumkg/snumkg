#encoding: utf-8
class UsersController < ApplicationController
  before_filter :check_signin, :except => [:create, :new ]
  layout 'main', :except => [:new, :create]
  def index
  end

  def new
    render :layout => 'default'

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
      when 5
        #매일매일에 댓글일 달릴때

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

    @all_alarms = Array.new

    # 여러명이 같은 글에 추천했을 때, 
    # 알람을 모아서 보여주자.
    types = [0, 1, 2, 3, 4]
    types.each do |type|
      @all_alarms = @all_alarms + select_alarm(type)
    end

    # new_alarms는 hash 배열. 
    # [{true => [...], false => [....]}, {true => [...], false => [...]}]
    #  -------article_id = 1------, ---------article_id = 2----
    #
    # new 값이 true를 가진 값들은 new_alarms에 삽입됨
    # hash key: true/false, value: 알람 배열
    new_count = 0
    
    @all_alarms.map! do |alarms|
      unless alarms[true].nil?
        new_count = new_count + 1
        if alarms[false].nil?
          {:new => true, :alarms => alarms[true].uniq { |alarm| alarm.alarmer}}
        else
          {:new => true, :alarms => (alarms[true] + alarms[false] ).uniq {|alarm| alarm.alarmer}}
        end
      else
        {:new => false, :alarms => alarms[false].uniq {|alarm| alarm.alarmer}}
      end
    end

   #@all_alarms = @new_alarms + @old_alarms
    #all_alarms 최근 순서대로 정렬
    @all_alarms.sort! do |a,b|
      a[:alarms][0].created_at < b[:alarms][0].created_at ? 1 : -1
    end

    respond_to do |format|
      
      format.html
      format.json {}
    end

   
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
