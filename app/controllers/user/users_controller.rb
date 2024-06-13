class User::UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :correct_user, only: [:edit, :update]
  before_action :ensure_guest_user, only: [:edit]
  
  def my_page
    @user = current_user
    @posts = @user.posts
    
    if params[:latest]
      @posts = current_user.posts.latest.page(params[:page]).per(12)
    elsif params[:old]
      @posts = current_user.posts.old.page(params[:page]).per(12)
    elsif params[:most_liked]
      @posts = Kaminari.paginate_array(current_user.posts.most_liked).page(params[:page]).per(12)
    elsif params[:best_answer] == "true"
      @posts = current_user.posts.joins(:comments).where(comments: { best_answer: true }).distinct.order(created_at: :desc).page(params[:page]).per(12)
    elsif params[:best_answer] == "false"
      @posts = current_user.posts.where.not(id: Comment.select(:post_id).where(best_answer: true)).order(created_at: :desc).page(params[:page]).per(12)
    else
      @posts = current_user.posts.latest.page(params[:page]).per(12)
    end
  end

  def show
    @user = User.find(params[:id])
    @posts = @user.posts

    if params[:latest]
      @posts = @user.posts.latest.page(params[:page]).per(12)
    elsif params[:old]
      @posts = @user.posts.old.page(params[:page]).per(12)
    elsif params[:most_liked]
      @posts = Kaminari.paginate_array(@user.posts.most_liked).page(params[:page]).per(12)
    elsif params[:best_answer] == "true"
      @posts = @user.posts.joins(:comments).where(comments: { best_answer: true }).distinct.order(created_at: :desc).page(params[:page]).per(12)
    elsif params[:best_answer] == "false"
      @posts = @user.posts.where.not(id: Comment.select(:post_id).where(best_answer: true)).order(created_at: :desc).page(params[:page]).per(12)
    else
      @posts = @user.posts.latest.page(params[:page]).per(12)
    end
  end

  def edit
    @user = User.find(current_user.id)
  end


  def unsubscribe
    @user = User.find(current_user.id)
  end

  def withdraw
    @user = User.find(current_user.id)
    @user.update(is_active: false)
    session.destroy
    flash[:notice] = "退会しました。再ログインできません。"
    redirect_to root_path
  end

  def index
  end

  def update
    @user = User.find(current_user.id)
    if @user.update(user_params)
      redirect_to my_page_path(@user), notice: 'ユーザー情報更新に成功しました'
    else
      render :edit
    end
  end

  def ensure_guest_user
    @user = User.find(params[:id])
    return unless @user.guest_user?
    redirect_to my_page_path, alert: "ゲストユーザーはプロフィール編集画面へ遷移できません。"
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :profile_image, :introduction)
  end
  
  def correct_user
    @user = User.find(params[:id])
    redirect_back(fallback_location: root_path, alert: '他のユーザーのプロフィールを編集する権限がありません。')
  end
end
