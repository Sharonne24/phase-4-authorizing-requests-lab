class MembersOnlyArticlesController < ApplicationController
  before_action :require_login
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  def index
    articles = Article.where(is_member_only: true).includes(:user).order(created_at: :desc)
    render json: articles, each_serializer: ArticleListSerializer
  end

  def show
    members_only_article = Article.find(params[:id])

    if members_only_article.is_member_only
      render json: members_only_article
    else
      render json: { error: 'Unauthorized - This article is not members-only' }, status: :unauthorized
    end
  end

  private

  def require_login
    unless session[:user_id]
      render json: { error: 'Unauthorized - Please log in' }, status: :unauthorized
    end
  end

  def record_not_found
    render json: { error: "Article not found" }, status: :not_found
  end

end
