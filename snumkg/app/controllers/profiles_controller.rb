#encoding: utf-8

require 'RMagick'
include Magick
class ProfilesController < ApplicationController
  before_filter :check_signin
  layout 'main'

  def show
    @user = User.find(params[:id])

    alarms = Alarm.where(:acceptor_id => current_user.id,
                        :alarm_type =>  3, :is_new => true)
    if params[:type] == "click_alarm" && alarms
      for alarm in alarms
        alarm.update_attribute(:is_new, false)
      end
    end
    @profile_comments = Comment.where(:profile_user_id => params[:id], :comment_type => 1)
    @profile_comment = Comment.new
  end

end
