module User::NotificationsHelper

  def unchecked_notifications
    current_user.passive_notifications.where(is_checked: false)
  end

end