#encoding: utf-8
class UsersController < ApplicationController
  before_filter :check_signin, :except => [:create,:update ]
  layout 'main'
  def index
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(params[:user])
    @user.set_password(@user.password)

    if @user.save
      session[:user_id] = @user.id
      redirect_to root_path
    else
      render 'new'
    end
  end

  def image
    name = params[:image].original_filename
    directory = File.join(Rails.root,'app/assets/images/profile/'+current_user.username)
    full_path = File.join(directory,name)
    

    if !File.directory?(directory)
      Dir.mkdir(directory)
    end

    if File.exist?(full_path)
      File.delete(full_path)
    end

    File.open(full_path,"wb") {|f| f.write(params[:image].read)}
    current_user.update_attribute(:profile_url,full_path)

    flash[:success] = "프로필 사진이 성공적으로 등록되었습니다."
    redirect_to user_path(current_user)

  end

  def get_profile_image

    send_file(User.find(params[:id]).profile_url, :type => 'image/png', :disposition => 'inline')
  end

  def show
    @user = User.find(params[:id])

    @profile_comments = Comment.where(:profile_user_id => params[:id], :comment_type => 1)
    @profile_comment = Comment.new

  end

  def alarms
=begin
    new_alarm_count = current_user.alarm_counts
    @alarms = current_user.alarms.where(:new => true).order("created_at desc")
    @new_alarms = new_alarm_count == 0 ? [] : @alarms[0..(new_alarm_count-1)]
    @old_alarms = @alarms[new_alarm_count..(@alarms.count)]
    session[:alarm_counts] = cucd 3	rrent_user.alarm_counts # 새로운 알람을 표시하기 위해 세션에 알림숫자를 저장해둠.
    current_user.update_attribute(:alarm_counts, 0)
=end
    def select_alarm(type)
      case type
      when 0, 1, 3, 4 
        # 내 글이 추천받을 때
        # 글에 댓글이 달렸을때
        # 내 프로필에 댓글이 달릴 때
        # 소꼬지 게시글에 참석한다고 할때
        Alarm.where(:alarm_type => type, :acceptor_id => current_user.id).order("CREATED_AT DESC").group_by(&:article_id).map {|article_id,alarms| alarms.group_by(&:new)}

      when 2
        # 내 댓글이 추천받을 때
        Alarm.where(:alarm_type => type, :acceptor_id => current_user.id).order("CREATED_AT DESC").group_by(&:comment_id).map {|a,alarms| alarms.group_by(&:new)}
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

    #old_alarms 순서대로 정렬
    @old_alarms.sort! do |a,b|
      if a[0].created_at < b[0].created_at 
        1
      else
        -1
      end
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
