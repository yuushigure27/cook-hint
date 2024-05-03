class User::PostsController < ApplicationController
  before_action :ensure_post, only: [:show, :edit, :update]
  
  def new
    @post = Post.new
  end
  
  def create
   @post = Post.new(post_params)

   if @post.save
    redirect_to post_path(@post) 
   else
    render :new
   end
  end

  def show
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
