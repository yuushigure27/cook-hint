class Admin::PostsController < ApplicationController
  before_action :authenticate_admin!

  def index
    @genres = Genre.all
    @posts = Post.order(created_at: :desc).page(params[:page]).per(10)
  end

  def show
    @post = Post.find(params[:id])
    @comment = Comment.new
  end

  def destroy
    @post = Post.find(params[:id])
    if @post.destroy
      flash[:notice] = "削除に成功しました"
      redirect_back(fallback_location: admin_posts_path)
    else
      flash[:alert] = "削除に失敗しました"
      redirect_back(fallback_location: admin_posts_path)
    end
  end
end
