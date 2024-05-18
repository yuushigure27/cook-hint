class User::PostsController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_post, only: [:show, :edit, :update]

  def new
    @post = Post.new
    @genres = Genre.all
  end

  def create
    @post = current_user.posts.build(post_params)
    if params[:post][:new_genre_name].present?
      genre = Genre.find_or_create_by(name: params[:post][:new_genre_name])
      @post.genre = genre
    end
    if @post.save
      redirect_to @post, notice: "投稿が作成されました。"
    else
      render 'new'
    end
  end

  def show
    @post = Post.find(params[:id])
    @comment = Comment.new
    @user = current_user
  end

  def edit
  end

  def index
    @genres = Genre.all
    @posts = Post.page(params[:page]).per(9)
    @post_all = Post.all
  end

  def update
    @post = Post.find(params[:id])
    if @post.update(post_params)
      redirect_to post_path(@post), notice: "投稿を更新しました"
    else
      @genres = Genre.all
      render :edit
    end
  end


  def destroy
    @post = Post.find(params[:id])
    if @post.destroy
      redirect_to posts_path, notice: "投稿を削除しました"
    else
      flash[:alert] = "削除に失敗しました"
      redirect_back(fallback_location: root_path)
    end
  end

  private

  def ensure_post
    @post = Post.find(params[:id])
  end

  def post_params
    params.require(:post).permit(:title, :introduction, :genre_id, :image, :new_genre_name)
  end



end
