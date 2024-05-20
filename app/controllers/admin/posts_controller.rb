class Admin::PostsController < ApplicationController
  before_action :authenticate_admin!
  
  def index
    @genres = Genre.all
    @posts = Post.page(params[:page]).per(10)
  end

  def show
    @post = Post.find(params[:id])
    @comment = Comment.new
  end

  def destroy
    @post = Post.find(params[:id])
    if @post.destroy
      redirect_to admin_posts_path, notice: "投稿を削除しました"
    else
      flash[:alert] = "削除に失敗しました"
      redirect_to admin_posts_path
    end
  end
end
