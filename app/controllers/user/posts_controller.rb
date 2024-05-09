class User::PostsController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_post, only: [:show, :edit, :update]

  def new
    @post = Post.new
    @genres = Genre.all
  end

  def create
   @post = Post.new(post_params)
   @post.user = current_user

   if @post.save
    redirect_to post_path(@post)
   else
    @genres = Genre.all
    render :new
   end
  end

  def show
    @post = Post.find(params[:id])
  end

  def edit
  end

  def index
    @posts = Post.all
  end

  private

  def ensure_post
    @post = Post.find(params[:id])
  end

  def post_params
    params.require(:post).permit(:title, :introduction, :genre_id, :image)
  end
  


end
