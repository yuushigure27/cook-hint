class User::UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_guest_user, only: [:edit]

  def show
    @user = current_user
  end

  def edit
    @user = User.find(params[:id])
  end

  def unsubscribe
  end

  def index
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      redirect_to user_path(@user), notice: "You have updated user successfully."
    else
      render "edit"
    end
  end
  
  private
  
  def ensure_guest_user
    @user = User.find(params[:id])
    return unless @user.guest_user?
    redirect_to users_my_page_path, alert: "ゲストユーザーはプロフィール編集画面へ遷移できません。"
  end  
end