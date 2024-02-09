class Post < ApplicationRecord
  belongs_to :user
  has_many :comments, dependent: :destroy
  has_many :bookmarks, dependent: :destroy
  has_many :favorites, dependent: :destroy

  has_many_attached :images

  validates :title, presence: true, length: { maximum: 255 }
  validates :body, length: { maximum: 65_535 }
  validate :image_content_type, :image_size, :image_length

  private

  def image_content_type
    images.each do |image|
      if !image.blob.content_type.in?(%w[image/jpeg image/jpg image/png image/gif])
        errors.add(:images, ": ファイル形式が、JPEG, JPG, PNG, GIF 以外になっています。ファイル形式をご確認ください。")
      end
    end
  end

  def image_size
    images.each do |image|
      if image.blob.byte_size > 5.megabytes
        errors.add(:images, ": 1枚あたり、5MB以下にしてください。")
      end
    end
  end

  def image_length
    if images.length > 4
      errors.add(:images, ": 4枚以下にしてください。")
    end
  end

  def self.ransackable_attributes(auth_object = nil)
    %w[title body comments.body]
  end

  def self.ransackable_associations(auth_object = nil)
    %w[comments]
  end
end
