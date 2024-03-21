class Notification < ApplicationRecord
  belongs_to :sender, class_name: 'User', foreign_key: 'sender_id'
  belongs_to :recipient, class_name: 'User', foreign_key: 'recipient_id'
  belongs_to :notifiable, polymorphic: true
  
  scope :unread, -> { where(read: false) }
  scope :unread_comment_replies, -> { where(read: false, notifiable_type: "CommentReply") }

  after_create_commit :broadcast_to_recipient

  private

  def broadcast_to_recipient
    broadcast_replace_later_to("notifications_for_user_#{recipient.id}", target: "notification_count", partial: "notifications/notification_count_frame", locals: { notification: self })
    broadcast_replace_later_to("notifications_for_user_#{recipient.id}", target: "notifications", partial: "notifications/notifications_frame")
  end

end
