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

  def show
  end

  def edit
  end

  def update
  end

  def destroy
  end 
end
