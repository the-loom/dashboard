class NotificationsController < ApplicationController
  layout "application2", only: [:index]

  def index
    authorize Notification
    @notifications = Notification.where(receiver: [nil, current_user])
    current_user.current_membership.read_notifications!
  end

  # XXX still in use?
  def create
    authorize Notification
    @notification = Notification.new(notification_params)
    @notification.author = current_user.full_name

    if @notification.valid?
      @notification.save
      # TODO: move to another thread!
      Course.current.memberships.each do |membership|
        membership.unread_notifications += 1
        membership.save!
      end

      redirect_to notifications_path
    else
      render :new
    end
  end

  private
    def notification_params
      params[:notification].permit(:subject, :text)
    end
end
