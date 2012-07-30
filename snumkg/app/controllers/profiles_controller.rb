#encoding: utf-8
class ProfilesController < ApplicationController
  before_filter :check_signin
  layout 'main'

  def image
    name = params[:image].original_filename
    directory = File.join(Rails.root,'app/assets/images/profile/'+current_user.username)
    full_path = File.join(directory,name)
    

    if !File.directory?(directory)
      Dir.mkdir(directory)
    end

    if File.exist?(full_path)
      File.delete(full_path)
    end

    File.open(full_path,"wb") {|f| f.write(params[:image].read)}
    current_user.update_attribute(:profile_url,full_path)

    flash[:success] = "프로필 사진이 성공적으로 등록되었습니다."
    redirect_to profile_path(current_user)

  end

  def get_profile_image

    send_file(User.find(params[:id]).profile_url, :type => 'image/png', :disposition => 'inline')
  end

  def show
    @user = User.find(params[:id])

    @profile_comments = Comment.where(:profile_user_id => params[:id], :comment_type => 1)
    @profile_comment = Comment.new

  end

  def create_comment
    @profile_comment = Comment.new
    @profile_comment.profile_user_id = params[:profile_user_id]
    @profile_comment.user_id = current_user.id unless current_user.nil?
    @profile_comment.content = params[:content]
    @profile_comment.comment_type = 1

=begin
    writers = Comment.where(:profile_user_id => params[:profile_user_id]).map {|comment| comment.writer}

    #글쓴이에게 알람
    save_alarm(Alarm.new, params[:profile_user_id], 3, :profile_user_id => params[:profile_user_id])

    #프로필에 댓글쓴 사람들에게 알람
    for writer in writers.uniq
      if current_user != writer && comment.writer != writer
        save_alarm(Alarm.new,writer.id,3,:profile_user_id => params[:profile_user_id])
      end
    end
=end

    @profile_comment.save

    redirect_to profile_path(params[:profile_user_id])
  end

  def destroy_comment
    #TODO
  end

end
