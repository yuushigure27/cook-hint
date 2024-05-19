class User::LikesController < ApplicationController
  before_action :authenticate_user!

  def create
    post = Post.find(params[:post_id])
    post.likes.create(user: current_user)
    redirect_back(fallback_location: "/posts")
  end

  def destroy
    post = Post.find(params[:post_id])
    like =current_user.likes.find_by(post_id: post.id)
    like.destroy if like
    redirect_back(fallback_location: "/posts")
  end

  def index
    @likes = current_user.likes.includes(:post)
    @posts =Post.where(id: @likes.pluck(:post_id))
  end
end
