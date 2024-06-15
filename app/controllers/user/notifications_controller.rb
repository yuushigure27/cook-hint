class User::NotificationsController < ApplicationController
  before_action :authenticate_user!

  def index
    @notifications = current_user.passive_notifications.unread.order(created_at: :desc).page(params[:page]).per(10)
  end






  def mark_all_as_read
    current_user.notifications.update_all(read: true)
    redirect_to notifications_path, notice: 'すべての通知を既読にしました。'
  end
end
