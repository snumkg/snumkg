#encoding: utf-8

class SearchController < ApplicationController

  def user_name
   @users = User.all
   @names = Array.new
   reg = Regexp.new(params[:search_name])

   if !params[:search_name].empty?
     @users.each do |user| 
       if (user.nickname =~ reg) 
         @names.push user 
       end
     end
   end

   respond_to do |format|
    
     format.js
   end

  end

  def user_id
    @user = User.find_by_username(params[:id].gsub("\"","")) unless params[:id].gsub("\"","").empty?

    if @user
      render :json => {:valid => false, :text => "이미 사용중인 ID가 있습니다."}.to_json
    else
      render :json => {:valid => "true", :text => "사용가능한 ID입니다."}.to_json
    end
  end

end
