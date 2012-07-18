#encoding: utf-8
module CommentsHelper

  def show_like_user(comment)
    cnt = comment.like_comments.count

    if cnt == 0
      " "
    elsif cnt == 1
      comment.like_comments.first.user.nickname + "님이 추천하셨습니다."
    else
      raw comment.like_comments.first.user.nickname + "님 외 <span class='like_list_btn' data-id='#{comment.id}'>#{cnt - 1}명</span>이 추천하였습니다."
    end
  end
end
