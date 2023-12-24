class Post < ApplicationRecord
  belongs_to :user

  has_many_attached :images

  validates :title, presence: true, length: { maximum: 255 }
  validates :body, length: { maximum: 65_535 }
  validate :image_content_type, :image_size, :image_length

  def image_content_type
    images.each do |image|
      if image.attached? && !image.blob.content_type.in?(%w[image/jpeg image/jpg image/png image/gif])
        errors.add(:images, ": ファイル形式が、JPEG, JPG, PNG, GIF 以外になっています。ファイル形式をご確認ください。")
      end
    end
  end

  def image_size
    images.each do |image|
      if image.attached? && image.blob.byte_size > 10.megabytes
        errors.add(:images, ": 1ファイルあたり、10MB以下にしてください。")
      end
    end
  end

  def image_length
    if images.length > 4
      errors.add(:images, ": 4枚以下にしてください。")
    end
  end
end
