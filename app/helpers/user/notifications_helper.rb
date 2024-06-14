module User::NotificationsHelper

  def unchecked_notifications
    current_user.passive_notifications.where(read: false)
  end

end