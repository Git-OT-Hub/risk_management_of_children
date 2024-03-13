class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :post, counter_cache: true
  has_many :comment_replies, dependent: :destroy

  has_one_attached :comment_image

  validates :body, presence: true, length: { maximum: 65_535 }
  validate :comment_image_content_type, :comment_image_size

  def comment_image_as_medium
    comment_image.variant(resize_to_limit: [500, 500]).processed.url
  end

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

  def self.ransackable_attributes(auth_object = nil)
    %w[body]
  end

  def self.ransackable_associations(auth_object = nil)
    %w[post]
  end
end
