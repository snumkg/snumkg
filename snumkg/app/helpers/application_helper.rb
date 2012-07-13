module ApplicationHelper
  def user
    User.find_by_id(session[:user_id])
  end
end
