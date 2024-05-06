class User::UsersController < ApplicationController
  def show
    @user = current_user
  end

  def edit
  end

  def unsubscribe
  end

  def index
  end
end
