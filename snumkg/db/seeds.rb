#coding: utf-8
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
#


#관리자
admin = User.new(username: "snumkg", email: "snumkg@gmail.com", nickname: "관리자", password: "abcdefg", password_confirmation: "abcdefg")
admin.set_password('snumkg12')
admin.save

#Tab
all_tab = Tab.create(name: "전체",   url_name: "all", admin_id: admin.id)
tab12 =   Tab.create(name: "12학번", url_name: "12",  admin_id: admin.id)
Tab.create(name: "11학번", url_name: "11", admin_id: admin.id)
Tab.create(name: "10학번", url_name: "10", admin_id: admin.id)
Tab.create(name: "09학번", url_name: "09", admin_id: admin.id)


#Board
board1 = Board.create(name: "소꼬지", tab_id: all_tab.id, url_name: "sokkoji", admin_id: admin.id)
board2 = Board.create(name: "자유게시판", tab_id: all_tab.id, url_name: "freeboard", admin_id: admin.id)
board3 = Board.create(name: "공지사항", tab_id: all_tab.id, url_name: "notice", admin_id: admin.id)
board4 = Board.create(name: "자유게시판", tab_id: tab12.id, url_name: "freeboard", admin_id: admin.id)


#Article
body_content = "안녕하세요 ㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋ첫번재글임"
Article.create(title: "첫번째 글", user_id: admin.id, board_id: board1.id, body: body_content)
Article.create(title: "두번째 글", user_id: admin.id, board_id: board1.id, body: body_content)
Article.create(title: "세번째 글", user_id: admin.id, board_id: board1.id, body: body_content)
Article.create(title: "네번째 글", user_id: admin.id, board_id: board1.id, body: body_content)
Article.create(title: "다섯번째 글", user_id: admin.id, board_id: board1.id, body: body_content)
Article.create(title: "여섯번째 글", user_id: admin.id, board_id: board1.id, body: body_content)

#comments

10.times do

  comment = Article.first.comments.new(content:"안녕하세요!!")
  comment.user_id = 1
  comment.save

end
