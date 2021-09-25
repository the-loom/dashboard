class NotificationsController < ApplicationController
  def index
    authorize Notification
    @notifications = Notification.where(receiver: [nil, current_user])
    current_user.current_membership.read_notifications!
  end
end
