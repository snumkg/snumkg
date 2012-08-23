#encoding: utf-8

require 'RMagick'
include Magick
class ProfilesController < ApplicationController
  before_filter :check_signin
  layout 'main'

  def show
    @user = User.find(params[:id])

    @profile_comments = Comment.where(:profile_user_id => params[:id], :comment_type => 1)
    @profile_comment = Comment.new


  end

end
