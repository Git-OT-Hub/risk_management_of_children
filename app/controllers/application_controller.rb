class ApplicationController < ActionController::Base
  # include ActiveStorage::SetCurrent  # rspec で画像投稿のテストをする際に、コメントアウトを外す
  add_flash_types :success, :info, :warning, :danger
  before_action :require_login
  before_action :set_notification_object

  include NotificationsHelper

  private

  def not_authenticated
    flash[:danger] = t("defaults.message.require_login")
    redirect_to login_path
  end

  def set_notification_object
    @notifications = current_user.received_notifications.unread.order(created_at: :desc) if current_user
  end
end
