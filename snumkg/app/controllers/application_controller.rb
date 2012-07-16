class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :get_tabs
  before_filter :set_tab_boards

  def user
    User.find_by_id(session[:user_id])
  end

  private
  def get_tabs
    @tabs = Tab.all
  end

  def set_user
  end

  def set_tab_boards
    @current_tab = Tab.find_by_url_name(params[:tab_name])
    @boards = @current_tab.boards if @current_tab
  end

  def signin?
    !session[:user_id].nil?
  end

  def check_signin
    redirect_to signin_path unless signin?
  end
end
