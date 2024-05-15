# frozen_string_literal: true

class User::SessionsController < Devise::SessionsController
  # before_action :configure_sign_in_params, only: [:create]
  before_action :user_state, only: [:create]

  def after_sign_in_path_for(resource)
    my_page_path
  end

  def after_sign_out_path_for(resource)
    root_path
  end

  def reject_inactive_user
    @user = user.find_by(email: params[:user][:email])
    if @user
      if @user.valid_password?(params[:user][:password]) && !@user.is_active
        flash[:danger] = 'このアカウントは退会済みです。申し訳ございませんが、別のメールアドレスをお使いください。'
        redirect_to new_user_session_path
      end
    end
  end


  #ゲストサインイン
  def guest_sign_in
    user = User.guest
    sign_in user
    redirect_to users_my_page_path, notice: "guestuserでログインしました。"
  end
  
  private
  #退会しているかいないか
  def user_state
    user = User.find_by(email: params[:user][:email])
    return if user.nil?
    return unless user.valid_password?(params[:user][:password])
    return unless user.is_active
    if user.is_active
    else
      flash[:alert] = "すでに退会されているアカウントです。管理者にお問い合わせください。"
      redirect_to new_user_registration_path
    end
  end


end
