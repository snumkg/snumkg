class SearchController < ApplicationController

  def user_name
   @users = User.all
   @names = Array.new
   reg = Regexp.new(params[:search_name])

   @users.each do |user| 
     if (user.nickname =~ reg) 
       @names.push user 
     end
   end

   respond_to do |format|
    
     format.js
   end

   

  end
end
