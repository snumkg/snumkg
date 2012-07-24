class ProfileCommentsController < ApplicationController

  def create_alarm_profile_comment(comment)
    if current_user != comment.user
      save_alarm(Alarm.new,comment.user_id,3,:comment_id => comment.id)
    end

    users = comment.user.profile_comments.map {|comment| comment.writer}

    for user in users.uniq
      if current_user != user && comment.user != user
        save_alarm(Alarm.new,comment.user_id,3,:comment_id => comment.id)
      end
    end
  end

  def create
    @profile_comment = ProfileComment.new
    @profile_comment.user_id = params[:profile_comment][:user_id]
    @profile_comment.writer_id = current_user.id
    @profile_comment.content = params[:profile_comment][:content]


    create_alarm_profile_comment(@profile_comment)

    @profile_comment.save

    redirect_to user_path(params[:profile_comment][:user_id])
  end

  def destrpy
    
  end
end
