class AuthController < ApplicationController
  layout 'main'
  def signout
    session[:user_id] = nil
    redirect_to root_path
  end

  def signin

  end

  def authorize
    if user = User.authentication(params[:username], params[:password])
      session[:user_id] = user.id
      redirect_to root_path
    else
      redirect_to root_path
    end
  end
end
