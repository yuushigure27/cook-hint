class User::SessionsController < Devise::SessionsController
  before_action :user_state, only: [:create]

  def after_sign_in_path_for(resource)
    users_my_page_path
  end

  def after_sign_out_path_for(resource)
    root_path
  end
  
  #ゲストサインイン
  def guest_sign_in
    user = User.guest
    sign_in user
    redirect_to users_my_page_path, notice: "guestuserでログインしました。"
  end
  
  private
  # アクティブであるかを判断するメソッド
  def user_state
    user = User.find_by(email: params[:user][:email])
    return if user.nil?
    return unless user.valid_password?(params[:user][:password])
    return unless user.is_active

    # アクティブでない会員の場合、ログインを許可しない
    flash[:danger] = 'このアカウントは退会済みです。申し訳ございませんが、別のメールアドレスをお使いください。'
    redirect_to new_user_session_path
  end
end