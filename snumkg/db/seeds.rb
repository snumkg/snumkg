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
admin = User.create(username: "snumkg", email: "snumkg@gmail.com")

all_tab = Tab.create(name: "전체",   url_name: "all", admin_id: admin.id)
tab12 =   Tab.create(name: "12학번", url_name: "12",  admin_id: admin.id)
Tab.create(name: "11학번", url_name: "11", admin_id: admin.id)
Tab.create(name: "10학번", url_name: "10", admin_id: admin.id)
Tab.create(name: "09학번", url_name: "09", admin_id: admin.id)

Board.create(name: "소꼬지", tab_id: all_tab.id, admin_id: admin.id)
Board.create(name: "자유게시판", tab_id: all_tab.id, admin_id: admin.id)
Board.create(name: "공지사항", tab_id: all_tab.id, admin_id: admin.id)
Board.create(name: "자유게시판", tab_id: tab12.id, admin_id: admin.id)

