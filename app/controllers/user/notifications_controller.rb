class User::NotificationsController < ApplicationController
  before_action :authenticate_user!

  def index
    @notifications = current_user.passive_notifications.unread
  end

  def mark_as_read
    @notification = current_user.passive_notifications.find(params[:id])
    @notification.update(read: true)
    redirect_to notifications_path
  end
  
end