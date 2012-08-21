#coding: utf-8
class ChatController < ApplicationController
	def index
		if session[:user_id].nil?
			render :text => '로그인하세요.'
		else
			@user = User.find(session[:user_id])
		end
	end
end
