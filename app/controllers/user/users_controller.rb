class User::UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_guest_user, only: [:edit]

  def show
    if params[:id].present?
      @user = User.find(params[:id])
    else
      @user = current_user
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
end
