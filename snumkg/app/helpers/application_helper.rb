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

  def user_profile_tag(user, options = {})
    #onmouseover, onmouseout, onclick 등의 이벤트 핸들링 함수는 shared.js에 정의되어있음
  	if user
      if options[:image]
        #이미지만 보여짐
        content_tag("div", nil, :class => "user-profile image", :user_id => user.id) do 
          content_tag("a", (
            image_tag(user.profile_image_thumb_url, :alt => user.nickname) + 
            (content_tag("div", class: "nickname") do
              content_tag("span", user.nickname)
            end)
          ), :href => profile_path(user), :onclick => "return show_profile(#{user.id});")
        end
      else
        #일반적인 프로필 (이미지 + 닉네임)
        content_tag("span", :class => "user-profile #{"large" if options[:size] == 'large'}") do 
          content_tag("a", (
            image_tag(user.profile_image_thumb_url, :alt => user.nickname) + " " + content_tag("span", user.nickname, :class => "user-profile-nickname")
          ), :href => profile_path(user), :onclick => "return show_profile(#{user.id});")
        end
      end
    else
      content_tag("span", :class => "user-profile") do 
				image_tag("/assets/default_profile_thumbnail.png", :alt => "익명", :size => (options[:small] ? "25x25" : nil)) + " " + content_tag("span", "익명", :class => "user-profile-nickname")
			end
		end
	end


  def show_like_user(comment)
    cnt = comment.likes.count

    if cnt == 0
      " "
    elsif cnt == 1
      comment.likes.first.user.nickname + "님이 좋아합니다."
    else
      raw comment.likes.first.user.nickname + "님 외 <span class='like_list_btn' data-id='#{comment.id}'>#{cnt - 1}명</span>이 좋아합니다."
    end
  end



end
