# frozen_string_literal: true

class User::RegistrationsController < Devise::RegistrationsController

  before_action :configure_sign_up_params, only: [:create]
  # before_action :configure_account_update_params, only: [:update]


  def sign_up_params
    params.require(:user).permit(:email, :password, :password_confirmation, :name)
  end

  def after_sign_up_path_for(resource)
    my_page_path
  end

  def after_update_path_for(resource)
    my_page_path
  end

  # ユーザー登録時の許可するパラメーター
  def configure_sign_up_params
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :email, :password, :password_confirmation])
  end

  # ユーザー情報更新時の許可するパラメーター
  def configure_account_update_params
    devise_parameter_sanitizer.permit(:account_update, keys: [:name, :email, :password, :password_confirmation, :current_password])
  end

  def update
    @user = current_user
    if @user.update(user_params)
      redirect_to my_page_path(@user), notice: 'ユーザー情報が更新されました。'
    else
       redirect_to users_edit_path(@user)
      # render "/users/#{@user.id}/edit"
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :current_password, :profile_image, :introduction )
  end
end


