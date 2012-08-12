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
end
