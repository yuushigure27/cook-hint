class Admin::UsersController < ApplicationController
  
  def index
    @users = User.all.page(params[:page])
  end

  def show
    @user = User.find(params[:id])
  end

  def edit
    @user = User.find(params[:id])
  end
  
  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      redirect_to admin_user_path(@user), notice: "ユーザー情報を更新しました。"
    else
      render :edit
    end  
  end
  
  def user_params
  params.require(:user).permit(:name, :email, :is_active)
  end
  
end
