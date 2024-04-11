class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :post, counter_cache: true
  has_many :comment_replies, dependent: :destroy
  has_many :comment_reply_users, through: :comment_replies, source: :user
  has_many :notifications, as: :notifiable, dependent: :destroy

  has_one_attached :comment_image do |attachable|
    attachable.variant :medium, resize_to_limit: [200, 200], preprocessed: true
  end

  validates :body, presence: true, length: { maximum: 1000 }
  validate :comment_image_content_type, :comment_image_size

  after_create_commit :create_comment_notification

  private

  def create_comment_notification
    return if self.user_id == self.post.user_id
    Notification.create(sender_id: self.user_id, recipient_id: self.post.user_id, notifiable: self, action: "comment_to_post") if self.post
  end

  def comment_image_content_type
    if comment_image.attached? && !comment_image.blob.content_type.in?(%w[image/jpeg image/jpg image/png image/gif])
      errors.add(:comment_image, ": ファイル形式が、JPEG, JPG, PNG, GIF 以外になっています。ファイル形式をご確認ください。")
    end
  end

  def comment_image_size
    if comment_image.attached? && comment_image.blob.byte_size > 5.megabytes
      errors.add(:comment_image, ": 1枚あたり、5MB以下にしてください。")
    end
  end

  def self.ransackable_attributes(auth_object = nil)
    %w[body]
  end

  def self.ransackable_associations(auth_object = nil)
    %w[post user]
  end
end
