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
    @user.set_password(@user.password)

    if @user.save

      session[:user_id] = @user.id
      respond_to do |format|
        format.js {}
      end
    else
      flash[:error] = "회원가입 할 수 없습니다. 회원정보를 다시 입력해주세요."
      redirect_to signin_path
    end
  end

  def edit
    @user = current_user
  end

  def update
    @user = User.find_by_id(params[:id])
    phone_number = params[:phone_number_1] + "-" + params[:phone_number_2] + "-" + params[:phone_number_3]
    @user.phone_number = phone_number

    #년도는 필요없기 때문에 2000년으로 적어놓음.
    birthday = "2000" + params[:birth_month] + "-" + params[:birth_day]
    @user.birthday = birthday
    @user.password = @user.password_confirmation = 'asdfgh'
    
    if @user.save
      redirect_to root_path
    end

  end

  def destroy
  end 

  #프로필 페이지
  def show
    @user = User.find(params[:id])

    @profile_comments = Comment.where(:profile_user_id => params[:id])
    @profile_comment = Comment.new
  end

  #프로필 이미지 다운로드
  def profile_image
    user = User.find_by_id(params[:id])
    default_profile_path = "#{Rails.root}/app/assets/images/default_profile_image.png"
    if user.nil? or user.profile_image_path.nil? # default_profile image 보여주기
      send_file(default_profile_path, :disposition => 'inline')
    else
      send_file(User.find(params[:id]).profile_image_path, :disposition => 'inline')
    end
  end

  #프로필 이미지(썸네일) 다운로드
  def profile_image_thumb
    user = User.find_by_id(params[:id])
    default_thumb_path = "#{Rails.root}/app/assets/images/default_profile_thumbnail.png"
    if user.profile_image_thumb_path.nil? # default_thumbnail 보여주기
      send_file(default_thumb_path, :disposition => 'inline')
    else
      send_file(User.find(params[:id]).profile_image_thumb_path, :disposition => 'inline')
    end
  end

  #알람 리스트의 뷰에 해당하는 액션
  #인자 : page
  def alarms
    @page = params[:page] || 1
    @user = current_user
    @alarm_groups = @user.alarm_groups.order("refreshed_at DESC").page(@page).per(5)
    @alarm_groups.each do |alarm_group|
      if alarm_group.state == 0 then
        alarm_group.state = 1
        alarm_group.save
      end
    end

    render :layout => false
  end

  def new_alarm_count
    if current_user then
      render :json => {count: current_user.new_alarm_count}
    else
      render :json => {count: 0}
    end
  end

  def change_alarm_state
    @alarm_group = AlarmGroup.find_by_id(params[:id])
    if @alarm_group and @alarm_group.accepter_id == session[:user_id] then
      @alarm_group.state = 2
      @alarm_group.save
      render :json => {alarm_group_id: @alarm_group.id, success: true}
    else
      render :json => {error: "에러"}
    end
  end

end
