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

  
  #ゲストサインイン
  def guest_sign_in
    user = User.guest
    sign_in user
    redirect_to my_page_path, notice: "guestuserでログインしました。"
  end
  
  private
  #退会しているかいないか
  def user_state
    # 【処理内容1】 入力されたemailからアカウントを1件取得
    user = User.find_by(email: params[:user][:email])
    # 【処理内容2】 アカウントを取得できなかった場合、このメソッドを終了する
    return if user.nil?
    # 【処理内容3】 取得したアカウントのパスワードと入力されたパスワードが一致していない場合、このメソッドを終了する
    return unless user.valid_password?(params[:user][:password])
    unless user.is_active
      flash[:alert] = "すでに退会されているアカウントです。管理者にお問い合わせください。"
      redirect_to new_user_registration_path
    end
  end


end
