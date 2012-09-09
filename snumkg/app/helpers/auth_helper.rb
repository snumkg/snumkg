module AuthHelper

  def current_user
    if @current_user.nil?
      @current_user = User.find_by_id(session[:user_id])
    else
      @current_user
    end
  end

  def signin?
    !current_user.nil?
  end

  def check_password
    if user = User.authentication(current_user.username, params[:password]) 
      session[:authorized_user] = true
      redirect_to contacts_path
    else
      flash[:error] = "Cannot access!"
      redirect_to root_path
    end
  end


end
