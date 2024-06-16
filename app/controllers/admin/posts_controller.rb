class Admin::PostsController < ApplicationController
  before_action :authenticate_admin!

  def index
    @genres = Genre.all
    @posts = Post.all.order(created_at: :desc).page(params[:page]).per(10)
  end
  


  def show
    @post = Post.find_by(id: params[:id])
    @comment = Comment.new
    @comments = @post.comments.order(created_at: :asc)
  end

  def destroy
    @post = Post.find_by(id: params[:id])
    if @post.destroy
      flash[:notice] = "削除に成功しました"
      redirect_to admin_posts_path
    else
      flash[:alert] = "削除に失敗しました"
      render :show
    end
  end
end
