class ChatController < ApplicationController
	def index
		@user = User.find(session[:user_id])
	end
end
