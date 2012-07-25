#coding: utf-8
# This file should contain all the record creation needed to seed the database with its default values.
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
admin = User.new(username: "snumkg", email: "snumkg@gmail.com", nickname: "관리자", password: "asdf", password_confirmation: "asdf")
admin.set_password("asdf")
tg = User.new(username: "xovsxo", email: "taegeonum@gmail.com", nickname: "엄태건", password: "asdf", password_confirmation: "asdf")
tg.set_password("asdf")
c = User.new(username: "asdf1", email: "asdf1@gmail.com", nickname: "홍쁘", password: "asdf", password_confirmation: "asdf")
c.set_password("asdf")
d = User.new(username: "asdf2", email: "asdf2@gmail.com", nickname: "김범준", password: "asdf", password_confirmation: "asdf")
d.set_password("asdf")
e = User.new(username: "asdf3", email: "asdf3@gmail.com", nickname: "백승범", password: "asdf", password_confirmation: "asdf")
e.set_password("asdf")

admin.save
tg.save
c.save
d.save
e.save


#Tab
all_tab = Tab.create(name: "전체", admin_id: admin.id)
tab12 =   Tab.create(name: "12학번", admin_id: admin.id)
Tab.create(name: "11학번",  admin_id: admin.id)
Tab.create(name: "10학번",  admin_id: admin.id)
Tab.create(name: "09학번",  admin_id: admin.id)


#Board

  board1 = Board.create(name: "암거나", tab_id: all_tab.id, admin_id: admin.id)
  board2 = Board.create(name: "자유게시판", tab_id: all_tab.id, admin_id: admin.id)
  board3 = Board.create(name: "공지사항", tab_id: all_tab.id, admin_id: admin.id)
  board4 = Board.create(name: "그냥겟판", tab_id: all_tab.id, admin_id: admin.id)

  Board.create(name: "소꼬지게시판", tab_id: all_tab.id, admin_id: admin.id, board_type: 1)

#Article
# article_type 0: 일반게시물, 1: 소꼬지게시물 
body_content = "안녕하세요 ㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋ첫번재글임"

for board in Board.all
  Article.create(title: "첫번째 글", user_id: random_number(1,User.all.count), board_id: board.id, body: body_content)
  Article.create(title: "두번째 글", user_id: random_number(1,User.all.count), board_id: board.id, body: body_content)
  Article.create(title: "세번째 글", user_id: random_number(1,User.all.count), board_id: board.id, body: body_content)
end
#comments
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
