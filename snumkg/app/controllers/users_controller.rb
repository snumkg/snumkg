class UsersController < ApplicationController
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
    directory = "#{Rails.root}/assets/images/profile"
    full_path = File.join(directory,name)
    file = File.new(full_path,"wb")
    file.write(params[:image].read)

    redirect_to root_path
    
  end

  def show
  end

  def alarms
    @alarms = current_user.alarms
    current_user.update_attribute(:alarm_counts, Alarm.where(acceptor_id: current_user.id).count)

    
  end

  def edit
  end

  def update
  end

  def destroy
  end 
end
