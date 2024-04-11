class CommentReply < ApplicationRecord
  belongs_to :user
  belongs_to :comment, counter_cache: true
  belongs_to :parent, class_name: "CommentReply", optional: true
  has_many :replies, class_name: "CommentReply", foreign_key: :parent_id, dependent: :destroy
  has_many :notifications, as: :notifiable, dependent: :destroy

  has_one_attached :comment_reply_image do |attachable|
    attachable.variant :medium, resize_to_limit: [200, 200], preprocessed: true
  end

  validates :body, presence: true, length: { maximum: 1000 }
  validate :comment_reply_image_content_type, :comment_reply_image_size

  after_create_commit :create_comment_reply_notification

  def call_parent(parent_id)
    parent = CommentReply.find(parent_id)
  end

  private

  def create_comment_reply_notification
    if self.parent.present?
      return if self.user_id == self.parent.user_id
      Notification.create(sender_id: self.user_id, recipient_id: self.parent.user_id, notifiable: self, action: "reply_to_comment_reply")
    else
      return if self.user_id == self.comment.user_id
      Notification.create(sender_id: self.user_id, recipient_id: self.comment.user_id, notifiable: self, action: "reply_to_comment") if self.comment
    end
  end

  def comment_reply_image_content_type
    if comment_reply_image.attached? && !comment_reply_image.blob.content_type.in?(%w[image/jpeg image/jpg image/png image/gif])
      errors.add(:comment_reply_image, ": ファイル形式が、JPEG, JPG, PNG, GIF 以外になっています。ファイル形式をご確認ください。")
    end
  end

  def comment_reply_image_size
    if comment_reply_image.attached? && comment_reply_image.blob.byte_size > 5.megabytes
      errors.add(:comment_reply_image, ": 5MB以下にしてください。")
    end
  end

  def self.ransackable_attributes(auth_object = nil)
    %w[body]
  end

  def self.ransackable_associations(auth_object = nil)
    %w[user]
  end
end
