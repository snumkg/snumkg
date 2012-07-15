#coding: utf-8
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
      flash.now[:error] = "아이디 혹은 비밀번호가 일치하지 않습니다."
      render 'signin'
    end
  end
end
