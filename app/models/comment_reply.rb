class CommentReply < ApplicationRecord
  belongs_to :user
  belongs_to :comment, counter_cache: true

  has_one_attached :comment_reply_image do |attachable|
    attachable.variant :medium, resize_to_limit: [500, 500], preprocessed: true
  end

  validates :body, presence: true, length: { maximum: 65_535 }
  validate :comment_reply_image_content_type, :comment_reply_image_size

  private

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
