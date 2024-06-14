class User::PostsController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_post, only: [:show, :edit, :update]
  before_action :check_guest_user, only: [:new, :create]
  before_action :correct_user, only: [:edit, :update]

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
      flash[:notice] = "投稿が作成されました。"
      redirect_to @post
    else
      flash.now[:alert] = "投稿に失敗しました。"
      render 'new'
    end
  end

  def show
    @post = Post.find(params[:id])
    @comment = Comment.new
    @comments = @post.comments.order(created_at: :asc).limit(5)
    @user = current_user
  end

  def edit
  end

  def index
    @genres = Genre.left_joins(:posts).group(:id).order('COUNT(posts.id) DESC')
    @post_all = Post.all
  
    if params[:latest]
      @posts = Post.latest.page(params[:page]).per(12)
    elsif params[:old]
      @posts = Post.old.page(params[:page]).per(12)
    elsif params[:most_liked]
      @posts = Kaminari.paginate_array(Post.most_liked).page(params[:page]).per(12)
    elsif params[:best_answer] == "true"
      @posts = Post.joins(:comments).where(comments: { best_answer: true }).distinct.order(created_at: :desc).page(params[:page]).per(12)
    elsif params[:best_answer] == "false"
      @posts = Post.where.not(id: Comment.select(:post_id).where(best_answer: true)).order(created_at: :desc).page(params[:page]).per(12)
    else
      @posts = Post.latest.page(params[:page]).per(12)
    end
  end





  def update
    @post = Post.find(params[:id])
    if @post.update(post_params)
      flash[:notice] = "更新しました。"
      handle_new_genre_name
      redirect_to post_path(@post)
    else
      flash.now[:alert] = "更新に失敗しました。"
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

  def check_guest_user
    if current_user.email == "guest@example.com"
      redirect_to posts_path, alert: "ゲストユーザーは新規投稿を作成できません。"
    end
  end

  def ensure_post
    @post = Post.find(params[:id])
  end

  def post_params
    params.require(:post).permit(:title, :introduction, :genre_id, :image, :new_genre_name)
  end

  def handle_new_genre_name
    if post_params[:new_genre_name].present?
      # 新しいジャンルを取得または作成して、投稿に関連付ける
      genre = Genre.find_or_create_by(name: post_params[:new_genre_name])
      @post.genre = genre
      @post.save
    end
  end
  
  def correct_user
    @post = Post.find(params[:id])
    unless @post.user == current_user
      redirect_back(fallback_location: root_path, alert: '他のユーザーの投稿を編集する権限がありません。')
    end
  end
end