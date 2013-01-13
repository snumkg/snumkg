#encoding: utf-8
require 'RMagick'
include Magick

class PicturesController < ApplicationController

  def create
		@user = current_user
    case params[:type]
    when "profile"
      if params[:image].nil?
        flash[:error] = "그림파일을 선택하세요."
        redirect_to :back
        return
      end

      name = params[:image].original_filename
      directory = File.join(Rails.root,'app/assets/images/profile/'+@user.username)
      full_path = File.join(directory, name)
      thumb_path = File.join(directory,"thumb_"+name)

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
      thumbnail = image.thumbnail_center(30, 30)
      thumbnail.write(thumb_path)

      @user.password = @user.password_confirmation = 'asdfgh'
      @user.update_attributes({
        :profile_image_path => full_path,
        :thumb_image_path => thumb_path
      })

      flash[:success] = "프로필 사진이 성공적으로 등록되었습니다."
      redirect_to profile_path(@user)
    when "album"
      p = params[:files].first
      @picture = Picture.new
      name = p.original_filename
      @picture.name = p.original_filename
      directory = File.join(Rails.root,'images/articles/', @user.username, Time.now.strftime("%y%m%d_%H%M"))
      @picture.full_path = full_path = File.join(directory,name)
      @picture.thumb_path = thumb_path = File.join(directory,"thumb_"+name)
      @picture.main_thumb_path = main_thumb_path = File.join(directory,"main_thumb_"+name)

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
      thumbnail = image.thumbnail_center(220, 220)
      thumbnail.write(thumb_path)

			#메인 슬라이드쇼 앨범 섬네일
      main_thumbnail = image.thumbnail_center(315, 355)
      main_thumbnail.write(main_thumb_path)

      if @picture.save
        @picture.url = picture_path(type: "album", id: @picture.id)
        @picture.thumb_url = picture_path(type: "album", thumb: "true", id: @picture.id)
        @picture.main_thumb_url = picture_path(type: "album", main_thumb: "true", id: @picture.id)
        @picture.save
        render :json => [@picture.to_jq_upload].to_json
      end

    end

  end

  def show
    case params[:type]
    when "album"
      if params[:thumb]
        send_file(Picture.find_by_id(params[:id]).thumb_path, :disposition => 'inline')
			elsif params[:main_thumb]
        send_file(Picture.find_by_id(params[:id]).main_thumb_path, :disposition => 'inline')
      else
        send_file(Picture.find_by_id(params[:id]).full_path, :disposition => 'inline')
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

#시점을 사진 가운데로 crop후 resizing
class ImageList
	def thumbnail_center(target_width, target_height)
		width = self.columns
		height = self.rows
		original_ratio = width.to_f / height.to_f
		target_ratio = target_width.to_f / target_height.to_f

		if original_ratio > target_ratio 
			#세로길이 유지, 가로 양옆이 잘림
			adjusted_width = (height * target_ratio).to_i
			thumbnail = self.crop((width/2) - (adjusted_width / 2), 0, adjusted_width, height)
		else 
			#가로길이 유지, 세로 양쪽이 잘림
			adjusted_height = (width / target_ratio).to_i
			thumbnail = self.crop(0, (height/2) - (adjusted_height / 2), adjusted_width, height)
		end

		thumbnail.thumbnail!(target_width, target_height)
		return thumbnail
	end
end
