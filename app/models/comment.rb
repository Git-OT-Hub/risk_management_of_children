class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :post

  has_one_attached :comment_image do |attachable|
    attachable.variant :thumb, resize_to_limit: [600, 600]
  end

  validates :body, presence: true, length: { maximum: 65_535 }
  validate :comment_image_content_type, :comment_image_size

  private

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
end
