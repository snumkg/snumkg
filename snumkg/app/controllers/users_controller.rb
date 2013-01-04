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

  def show
    @user = User.find(params[:id])

    @profile_comments = Comment.where(:profile_user_id => params[:id], :comment_type => 1)
    @profile_comment = Comment.new

  end

  def alarms
    @user = current_user
    @alarm_groups = @user.alarm_groups

    @all_alarms = @user.alarm_groups.order("updated_at DESC").map{|alarm_group| {
      is_new: alarm_group.is_new,
      text: alarm_group.alarm_text
    }}

    render :layout => false
    
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


end
