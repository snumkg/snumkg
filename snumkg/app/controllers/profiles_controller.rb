#encoding: utf-8

require 'RMagick'
include Magick
class ProfilesController < ApplicationController
  before_filter :check_signin, :except => [:get_profile_image]
  layout 'main'

  def upload_profile_image
    name = params[:image].original_filename
    directory = File.join(Rails.root,'app/assets/images/profile/'+current_user.username)
    full_path = File.join(directory,name)
    thumbnail_path = File.join(directory,"t_"+name)
    

    if !File.directory?(directory)
      Dir.mkdir(directory)
    end

    if File.exist?(full_path)
      File.delete(full_path)
    end

    File.open(full_path,"wb") {|f| f.write(params[:image].read)}
    image = ImageList.new(full_path);
    
    width = image.columns
    height = image.rows

    if (width > height)
      thumbnail = image.crop((width/2) - (height/2), 0, height, height)
    else
      thumbnail = image.crop(0,(height/2) - (width/2), width, width)
    end

    thumbnail.thumbnail!(30,30)
    thumbnail.write(thumbnail_path)

    current_user.update_attribute(:profile_image_path,full_path)
    current_user.update_attribute(:thumbnail_image_path, thumbnail_path)

    flash[:success] = "프로필 사진이 성공적으로 등록되었습니다."
    redirect_to profile_path(current_user)

  end

  def get_profile_image
    default_thumb_path = "#{Rails.root}/app/assets/images/default_profile_thumbnail.png"
    default_profile_path = "#{Rails.root}/app/assets/images/default_profile_image.png"

    user = User.find_by_id(params[:id])

    if params[:thumb].nil?  # 프로필 이미지 보여주기
      if user.profile_image_path.nil? # default_profile image 보여주기
        send_file(default_profile_path, :type => 'image/png', :disposition => 'inline')
      else
        send_file(User.find(params[:id]).profile_image_path, :type => 'image/png', :disposition => 'inline')
      end
    else # 썸네일 이미지 보여주기
      if user.thumbnail_image_path.nil? # default_thumbnail 보여주기
        send_file(default_thumb_path, :type => 'image/png', :disposition => 'inline')
      else
        send_file(User.find(params[:id]).thumbnail_image_path, :type => 'image/png', :disposition => 'inline')
      end
    end
    
  end

  def show
    @user = User.find(params[:id])

    @profile_comments = Comment.where(:profile_user_id => params[:id], :comment_type => 1)
    @profile_comment = Comment.new

  end

end
