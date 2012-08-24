#encoding: utf-8

require 'RMagick'
include Magick

class PicturesController < ApplicationController

  def create
  	if params[:image].nil?
  		flash[:error] = "그림파일을 선택하세요."
  		redirect_to :back
  		return
		end
    case params[:type]
    when "profile"
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
      #썸네일 이미지 만들기
      #가로 세로 크기가 다를 시 
      #작은 크기에 맞게 잘라줘서
      #resizing
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
    when "album"
      p = params[:files].first
      @picture = Picture.new
      name = p.original_filename
      @picture.name = p.original_filename
      directory = File.join(Rails.root,'images/articles/',current_user.username,Time.now.strftime("%y_%m_%d_%H_%M"))
      @picture.full_path = full_path = File.join(directory,name)
      @picture.thumb_path = thumbnail_path = File.join(directory,"t_"+name)

      # 폴더가 없을 시에 폴더를 만들어줌. recursive하게
      if !File.directory?(directory)
        FileUtils.mkdir_p(directory)
      end
      if File.exist?(full_path)
        File.delete(full_path)
      end
      #앨범 사진 저장
      File.open(full_path,"wb") {|f| f.write(p.read)}

      # index에서 보여주기 위한 앨범 썸네일 저장
      image = ImageList.new(full_path);
      image.resize_to_fill!(220)
      image.write(thumbnail_path)


      if @picture.save
        @picture.url = picture_path(type: "album", id: @picture.id)
        @picture.thumbnail_url =  picture_path(type: "album", thumb: "true", id: @picture.id)
        @picture.save
        render :json => [@picture.to_jq_upload].to_json
      end

    end


  end

  def show
    default_thumb_path = "#{Rails.root}/app/assets/images/default_profile_thumbnail.png"
    default_profile_path = "#{Rails.root}/app/assets/images/default_profile_image.png"

    case params[:type]
    when "profile"
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
    when "album"
      if params[:thumb].nil?
        send_file(Picture.find_by_id(params[:id]).full_path, :type => 'image/jpg', :disposition => 'inline')
      else
        send_file(Picture.find_by_id(params[:id]).thumb_path, :type => 'image/jpg', :disposition => 'inline')
      end
    end
 
  end

  def destroy
    @picture = Picture.find_by_id(params[:id])
    if @picture.destroy
      render :json => true
    end
    
  end
end
