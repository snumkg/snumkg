module AuthHelper

  def current_user
    User.find_by_id(session[:user_id])
  end

  def signin?
    !current_user.nil?
  end

end
