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

    @profile_comments = @user.profile_comments
    @profile_comment = ProfileComment.new

  end

  def alarms
    new_alarm_count = current_user.alarm_counts
    @alarms = current_user.alarms.order("created_at desc")
    @new_alarms = new_alarm_count == 0 ? [] : @alarms[0..(new_alarm_count-1)]
    @old_alarms = @alarms[new_alarm_count..(@alarms.count)]
    session[:alarm_counts] = current_user.alarm_counts # 새로운 알람을 표시하기 위해 세션에 알림숫자를 저장해둠.
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
