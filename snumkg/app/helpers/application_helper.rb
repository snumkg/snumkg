#coding: utf-8
module ApplicationHelper include AuthHelper

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

  #입학년도 문자열을 배열로 리턴 ['13', '12' .. '00']
  def entrance_years
    years = (0..((Time.now + 3.month).year - 2000))
    (years.map do |year|
      if year >= 10 then
        year.to_s
      else
        "0#{year}"
      end
    end).reverse
  end

  #학과 hash를 리턴
  def departments_hash
    {
    "간호학과" => "간호",
    "경영학과" => "경영",
    "건설환경공학부" => "건환공",
    "기계항공공학부" => "기항",
    "재료공학부" => "재료",
    "전기정보공학부" => "전기",
    "컴퓨터공학부" => "컴공",
    "화학생물공학부" => "화생공",
    "건축공학과" => "건공",
    "건축학과" => "건축",
    "산업공학" => "산공",
    "에너지자원공학" => "에너지",
    "원자핵공학" => "원핵",
    "조선해양공학" => "조선",
    "농경제사회학부" => "농경제",
    "식물생산과학부" => "식생",
    "산림과학부" => "산림",
    "식품,동물생명공학부" => "식동",
    "응용생물화학부" => "응생",
    "조경,지역시스템공학부" => "지시공",
    "바이오시스템,소재학부" => "바시소",
    "디자인학부 (디자인)" => "디자인",
    "디자인학부 (공예)" => "공예",
    "동양화과" => "동양",
    "서양화과" => "서양",
    "조소과" => "조소",
    "교육학과" => "교육",
    "윤리교육과" => "윤교",
    "국어교육과" => "국교",
    "외국어교육계열(광역)" => "외교",
    "영어교육과" => "영교",
    "독어교육과" => "독교",
    "불어교육과" => "불교",
    "사회교육계열(광역)" => "사교",
    "역사교육과" => "역교",
    "지리교육과" => "지교",
    "수학교육과" => "수교",
    "과학교육계열(광역)" => "과교",
    "물리교육과" => "물교",
    "화학교육과" => "화교",
    "생물교육과" => "생교",
    "지구과학교육과" => "지과교",
    "체육교육과" => "체교",
    "사회과학계열(광역)" => "사과",
    "정치외교학부" => "정외",
    "경제학부" => "경제",
    "사회학과" => "사회",
    "심리학과" => "심리",
    "사회복지학과" => "복지",
    "언론정보학과" => "언론",
    "인류학과" => "인류",
    "지리학과" => "지리",
    "소비자아동학부" => "소아",
    "의류학과" => "의류",
    "식품영양학과" => "식영",
    "수의예과" => "수의예",
    "성악과" => "성악",
    "작곡과" => "작곡",
    "기악과" => "기악",
    "국악과" => "국악",
    "의예과" => "의예",
    "인문계열(광역)" => "인문",
    "국어국문학과" => "국문",
    "중어중문학과" => "중문",
    "영어영문학과" => "영문",
    "불어불문학과" => "불문",
    "독어독문학과" => "독문",
    "노어노문학과" => "노문",
    "서어서문학과" => "서문",
    "언어학과" => "언어",
    "아시아언어문명학부" => "아언",
    "국사학과" => "국사",
    "동양사학과" => "동사",
    "서양사학과" => "서사",
    "고고미술사학과" => "고미",
    "철학과" => "철학",
    "종교학과" => "종교",
    "미학과" => "미학",
    "수리과학부 " => "수리",
    "통계학과" => "통계",
    "물리ㆍ천문학부(광역)" => "물천",
    "천문학부" => "천문",
    "화학부" => "화학",
    "생명과학부" => "생명",
    "지구환경과학부" => "지환",
    "자유전공학부" => "자전"
    }
  end


end
