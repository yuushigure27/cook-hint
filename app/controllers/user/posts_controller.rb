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

    if @post.new_genre_name.present?
      new_genre = Genre.create(name: @post.new_genre_name)
      @post.genre_id = new_genre.id
    end

   if @post.save
    redirect_to post_path(@post)
   else
    @genres = Genre.all
    render :new
   end
  end

  def show
    @post = Post.find_by(params[:id])
    @comment = Comment.new
    @user = current_user
  end

  def edit
  end

  def index
    @posts = Post.all
  end

  def destroy
    @user = User.find(current_user.id)
    @user.update(is_active: false)
    session.destroy
    flash[:notice] = "退会しました。再ログインできません。"
    redirect_to root_path
  end

  private

  def ensure_post
    @post = Post.find(params[:id])
  end

  def post_params
    params.require(:post).permit(:title, :introduction, :genre_id, :image, :new_genre_name)
  end



end
