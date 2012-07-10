class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :get_tabs
  before_filter :set_tab_boards

  private
  def get_tabs
    @tabs = Tab.all
  end

  def set_tab_boards
    @current_tab = Tab.find_by_url_name(params[:tab_name])
    @boards = @current_tab.boards if @current_tab
  end
end
