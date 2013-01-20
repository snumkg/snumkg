#encoding: utf-8
module CommentsHelper

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
