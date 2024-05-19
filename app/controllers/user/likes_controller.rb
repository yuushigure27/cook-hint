class User::LikesController < ApplicationController
  before_action :authenticate_user!

  def create
    post = Post.find(params[:post_id])
    post.likes.create(user: current_user)
    redirect_to post
  end

  def destroy
    post = Post.find(params[:post_id])
    like =current_user.likes.find_by(post_id: post.id)
    like.destroy if like
    redirect_to post
  end

  def index
    @likes = current_user.likes.includes(:post)
    @likes_genre = @likes.where(posts: { genre_id: params[:genre_id] }) if params[:genre_id].present?
  end
end
