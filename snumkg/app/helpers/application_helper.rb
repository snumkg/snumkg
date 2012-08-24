#coding: utf-8
module ApplicationHelper
  include AuthHelper

  def article_path_helper(type, article_id)
    case type
    when "index"
      articles_path(group_id: params[:group_id], board_id: params[:board_id])
    when "show"
      article_path(group_id: params[:group_id], board_id: params[:board_id], id:article_id)
    when "edit"
      edit_article_path(group_id: params[:group_id], board_id: params[:board_id])
    end
    
  end

  def user_profile_tag(user_id, options = {})
  	user = User.find_by_id(user_id)
  	if user
			content_tag("span", :class => "user-profile") do 
				content_tag("a", (
					image_tag(picture_path(type: "profile", id: user_id, thumb:true), :alt => user.nickname, :size => (options[:small] ? "25x25" : nil)) + " " + content_tag("span", user.nickname, :class => "user-profile-nickname")
				), :href => profile_path(user.id))
			end
		else
			content_tag("span", :class => "user-profile") do 
				image_tag("/assets/default_profile_thumbnail.png", :alt => "익명", :size => (options[:small] ? "25x25" : nil)) + " " + content_tag("span", "익명", :class => "user-profile-nickname")
			end
		end
	end
end
