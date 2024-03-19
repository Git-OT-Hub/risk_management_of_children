class NotificationsController < ApplicationController

  def update
    @notification = current_user.received_notifications.find(params[:id])
    @notification.update(read: true)
    if @notification
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: [
            turbo_stream.remove(@notification),
            turbo_stream.replace("notification_count", partial: "notifications/notification_count")
          ]
        end
        format.html {  }
      end
    else
      redirect_to root_path, danger: t("notifications.index.update_fail")
    end
  end

  def mark_all_as_read
    @notifications = current_user.received_notifications.unread
    if @notifications.present?
      @notifications.update_all(read: true)
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: [
            turbo_stream.replace("notifications", partial: "notifications/notifications"),
            turbo_stream.replace("notification_count", partial: "notifications/notification_count")
          ]
        end
        format.html {  }
      end
    else
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: [
            turbo_stream.replace("notifications", partial: "notifications/notifications"),
            turbo_stream.replace("notification_count", partial: "notifications/notification_count")
          ]
        end
        format.html {  }
      end
    end
  end
end
