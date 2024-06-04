class User::LikesController < ApplicationController
  before_action :authenticate_user!
  before_action :check_guest_user, only: [:create, :destroy]

  def create
    @action_name = params[:action_name]
    @post = Post.find(params[:post_id])
    @likes= current_user.likes.create(post_id: @post.id)
    #redirect_back(fallback_location: "/posts")
    post.create_notification_like!(current_user)
  end

  def destroy
    @action_name = params[:action_name]
    @post = Post.find(params[:post_id])
    @like = current_user.likes.find_by(post_id: @post.id)
    @like.destroy 
    #redirect_back(fallback_location: "/posts")
  end

  def index
    @likes = current_user.likes.includes(:post)
    @posts = Post.where(id: @likes.pluck(:post_id)).order(created_at: :desc).page(params[:page]).per(12)
  end
  
  private

  def check_guest_user
    if current_user.email == "guest@example.com"
      redirect_back fallback_location: root_path, alert: "ゲストユーザーはいいねを押せません。"
    end
  end
  
  
end