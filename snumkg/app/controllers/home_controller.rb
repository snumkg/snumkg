class HomeController < ApplicationController
  layout 'main'

  def index
  end

  def group
  end

  def all
    @all = Article.all + Comment.all + Like.all + Attendance.all 
    @all.sort! do |a,b|
      a.created_at < b.created_at ? 1 : -1
    end
  end

end
