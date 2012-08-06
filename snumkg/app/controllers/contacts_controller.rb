#encoding: utf-8
class ContactsController < ApplicationController
  layout 'main'


  def index
   @users = User.all
  end


  def check_password
    
    if user = User.authentication(current_user.username, params[:password]) && current_user.admin?
      session[:authorized_contact_user] = true
      redirect_to contacts_path
    else
      if user.nil?
      flash[:error] = "비밀번호가 잘못되었습니다."
      else
        flash[:error] = "접근가능한 사용자가 아닙니다."
      end
      redirect_to contacts_path
    end
  end
end
