#coding: utf-8
# This file should contain all the record creation needed to seed the dagroupase with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
#

def random_number(min,max)
  Random.new.rand(min..max)
end



#User
p_path = "#{Rails.root}/app/assets/images"
admin = User.new(username: "snumkg", email: "snumkg@gmail.com", nickname: "관리자", password: "asdf", password_confirmation: "asdf", is_admin: true)
admin.set_password("asdf")
admin.save
tg = User.new(username: "xovsxo", email: "taegeonum@gmail.com", nickname: "엄태건", password: "asdf", password_confirmation: "asdf", profile_image_path: "#{p_path}/default1.jpg", profile_image_thumb_path: "#{p_path}/t_default1.jpg")
tg.set_password("asdf")
tg.save
user = User.new(username: "asdf1", email: "asdf1@gmail.com", nickname: "홍쁘", password: "asdf", password_confirmation: "asdf", profile_image_path: "#{p_path}/default2.jpg", profile_image_thumb_path: "#{p_path}/t_default2.jpg")
user.set_password("asdf")
user.save
user = User.new(username: "asdf2", email: "asdf2@gmail.com", nickname: "김범준", password: "asdf", password_confirmation: "asdf", profile_image_path: "#{p_path}/default3.jpg", profile_image_thumb_path: "#{p_path}/t_default3.jpg")
user.set_password("asdf")
user.save
user = User.new(username: "asdf3", email: "asdf3@gmail.com", nickname: "백승범", password: "asdf", password_confirmation: "asdf", profile_image_path: "#{p_path}/default4.jpg", profile_image_thumb_path: "#{p_path}/t_default4.jpg")
user.set_password("asdf")
user.save
user = User.new(username: "asdf4", email: "asdf4@gmail.com", nickname: "이종민", password: "asdf", password_confirmation: "asdf", profile_image_path: "#{p_path}/default1.jpg", profile_image_thumb_path: "#{p_path}/t_default1.jpg")
user.set_password("asdf")
user.save
user = User.new(username: "asdf5", email: "asdf5@gmail.com", nickname: "홍길동", password: "asdf", password_confirmation: "asdf", profile_image_path: "#{p_path}/default2.jpg", profile_image_thumb_path: "#{p_path}/t_default2.jpg")
user.set_password("asdf")
user.save
user = User.new(username: "asdf6", email: "asdf6@gmail.com", nickname: "김영희", password: "asdf", password_confirmation: "asdf", profile_image_path: "#{p_path}/default3.jpg", profile_image_thumb_path: "#{p_path}/t_default3.jpg")
user.set_password("asdf")
user.save
user = User.new(username: "asdf7", email: "asdf7@gmail.com", nickname: "박철수", password: "asdf", password_confirmation: "asdf", profile_image_path: "#{p_path}/default4.jpg", profile_image_thumb_path: "#{p_path}/t_default4.jpg")
user.set_password("asdf")
user.save
user = User.new(username: "asdf8", email: "asdf8@gmail.com", nickname: "뀨잉", password: "asdf", password_confirmation: "asdf", profile_image_path: "#{p_path}/default1.jpg", profile_image_thumb_path: "#{p_path}/t_default1.jpg")
user.set_password("asdf")
user.save
user = User.new(username: "asdf9", email: "asdf9@gmail.com", nickname: "뿌잉", password: "asdf", password_confirmation: "asdf", profile_image_path: "#{p_path}/default2.jpg", profile_image_thumb_path: "#{p_path}/t_default4.jpg")
user.set_password("asdf")
user.save



#Group
all_group = Group.create(name: "전체", admin_id: admin.id)
group12 =   Group.create(name: "12학번", admin_id: admin.id, group_type: "학번")
Group.create(name: "11학번",  admin_id: admin.id, group_type: "학번")
Group.create(name: "10학번",  admin_id: admin.id, group_type: "학번")
Group.create(name: "09학번",  admin_id: admin.id, group_type: "학번")
sokkoji = Group.create(name: "소꼬지",  admin_id: admin.id, group_type: "소꼬지")


#Board

groups = Group.where(:group_type => "학번")

  board2 = Board.create(name: "자유게시판", group_id: all_group.id, admin_id: admin.id, board_type: "일반")
  board3 = Board.create(name: "공지사항", group_id: all_group.id, admin_id: admin.id, board_type: "일반")
  board4 = Board.create(name: "그냥겟판", group_id: all_group.id, admin_id: admin.id, board_type: "일반")

for group in groups 
  Board.create(name: "자유게시판", group_id: group.id, admin_id: admin.id, board_type: "일반")
  Board.create(name: "공지사항", group_id: group.id, admin_id: admin.id, board_type: "일반")
  Board.create(name: "그냥겟판", group_id: group.id, admin_id: admin.id, board_type: "일반")

end

  #소꼬지 board
  Board.create(name: "소꼬지 후기", group_id: sokkoji.id, admin_id: admin.id, board_type: "소꼬지 후기")
  s = Board.create(name: "소꼬지 게시판", group_id: sokkoji.id, admin_id: admin.id, board_type: "소꼬지")
  Board.create(name: "일정보기", group_id: sokkoji.id, admin_id: admin.id, board_type: "소꼬지 일정")
  #앨범
  album = Board.create(name: "앫범게시판", group_id: all_group.id, admin_id: admin.id, board_type: "앨범")
  anonymous = Board.create(name: "익명게시판", group_id: all_group.id, admin_id: admin.id, board_type: "익명")


  #Articlet
body_content = "안녕하세요 ㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋ"

25.times do 
  Article.create(title: "첫번째 글", user_id: random_number(1,User.all.count), board_id: 1, body: body_content)
end

for board in Board.where(:board_type => "일반")
  # 일반게시판 아티클
	Article.create(title: "공지입니당.", user_id: random_number(1,User.all.count), board_id: board.id, body: body_content,is_notice: true)
	Article.create(title: "첫번째 글", user_id: random_number(1,User.all.count), board_id: board.id, body: body_content)
	Article.create(title: "두번째 글", user_id: random_number(1,User.all.count), board_id: board.id, body: body_content)
end

#앨범게시물
10.times do
	Article.create(title: "롯월 소꼬지", user_id: random_number(1,User.all.count), board_id: album.id, body: body_content)
end

directory = File.join(Rails.root, "images")
for article in Board.where(:board_type => "앨범").limit(1).first.articles
	num = random_number(1,5).to_s
	full_path = File.join(directory,num + ".jpg")
	p = Picture.new
	p.save
	p.full_path = full_path
	p.url = "/pictures/#{p.id}?type=album"
	p.name = "aaa"
	p.thumb_path = "#{directory}/t_"+num+".jpg"
	p.thumb_url = "/pictures/#{p.id}?type=album&thumb=true"
	p.article_id = article.id
	p.save
end

#소꼬지게시판 아티클
6.times do 
	Article.create(title: "바보 소꼬지", user_id: random_number(1,User.all.count), board_id: s.id, body: body_content, date: Time.now + random_number(-3,3)*60*60*24)
end

#매일매일

everyday_group = Group.create(name: "매일매일",  admin_id: admin.id, group_type: "매일매일")
everyday_board = Board.create(name: "매일매일", group_id: everyday_group.id, admin_id: admin.id, board_type: "매일매일")

10.times do 
	Article.create(title: "asdf",body: "여러분 방가방가 ㅋㄷㅋㄷㅋㄷ 쿄쿜", user_id: random_number(1,User.all.count), board_id: everyday_board.id)
end

for post in everyday_board.articles 
	comment = post.comments.new
	comment.content = "오홍 방가워염"
	comment.user_id = random_number(1, User.all.count)
	comment.save
end

#샘플 알람 생성을 위한
1.upto(10) do |i|
	article = Article.create(title: "안뇽하세용키키키키 #{i}", body: "딩가딩가", user_id: 1, board_id: 1)
	comment = Comment.new
  comment.article_id = article.id
	comment.user_id = ((i-1) % 10) + 1
	comment.content = "댓글 #{i}"
	comment.save
end

#샘플 알람 생성을 위한
1.upto(10) do |i|
	article = Article.last
  like = Like.new
	like.user_id = ((i-1) % 10) + 1
	like.article_id = article.id
  like.save
end


#comments

=begin
Article.all.each do |article|
	random_number(0,5).times do

		comment = article.comments.new(content:"안녕하세요!!")
		comment.user_id = random_number(1,User.all.count)
		comment.save

	end
end
Article.all.each do |article|
	random_number(0,5).times do
		like = article.like_articles.new
		like.user_id = random_number(1,User.all.count)
		like.save
	end
end

Comment.all.each do |comment|
	random_number(0,5).times do
		like = comment.like_comments.new
		like.user_id = random_number(1,User.all.count)
		like.save
	end
end
=end
