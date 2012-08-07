#encoding: utf-8
class ContactsController < ApplicationController
  before_filter :check_signin
  layout 'main'


  def index
    if !current_user.admin?
      flash[:error] = "접근가능한 사용자가 아닙니다."
      redirect_to root_path
    else
      if session[:authorized_contact_user] != true
        redirect_to '/contacts/password_confirmation'
      else
        @users = User.all
      end
    end
  end

  def password_confirmation
    
  end


  def check_password
    
    if user = User.authentication(current_user.username, params[:password]) && current_user.admin?
      session[:authorized_contact_user] = true
      redirect_to contacts_path
    else
      flash[:error] = "비밀번호가 잘못되었습니다."
      redirect_to contacts_path
    end
  end
end
