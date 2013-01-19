#coding: Utf-8
class AdminController < ApplicationController
  layout 'admin'
  before_filter :check_admin

  def check_admin
    user = User.find_by_id(session[:user_id])
    if user.nil? or !user.is_admin
      flash[:error] = '권한이 없습니다.'
      redirect_to root_path
    end
  end

  def index
  end
end
