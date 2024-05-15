class User::LikesController < ApplicationController
  before_action :authenticate_user!

  def create
    post = Post.find(params[:post_id])
    post.likes.create(user: current_user)
    redirect_to post
  end

  def destroy
    post = Post.find(params[:post_id])
    like = post.likes.find_by(user: current_user)
    like.destroy if like
    redirect_to post
  end
  
  def index
    @likes = current_user.likes.includes(:post)
  end
end
