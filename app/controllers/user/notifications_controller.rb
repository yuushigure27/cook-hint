class User::NotificationsController < ApplicationController
  before_action :authenticate_user!

  def index
    @notifications = current_user.passive_notifications.page(params[:page]).per(20)
    @notifications.where(is_checked: false).each do |notification|
      notification.update(is_checked: true)
    end
  end

  def destroy
    @notifications = current_user.passive_notifications.destroy_all
    redirect_to notifications_path
  end
  
end