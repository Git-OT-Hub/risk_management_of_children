class Post < ApplicationRecord
  belongs_to :user
  has_many :comments, dependent: :destroy
  has_many :bookmarks, dependent: :destroy
  has_many :favorites, dependent: :destroy

  has_many_attached :images do |attachable|
    attachable.variant :medium, resize_to_limit: [300, 300], preprocessed: true
  end

  validates :title, presence: true, length: { maximum: 50 }
  validates :body, length: { maximum: 1000 }
  validates :item_info, length: { maximum: 1000 }
  validates :item_merit, length: { maximum: 1000 }
  validates :item_demerit, length: { maximum: 1000 }
  validate :image_content_type, :image_size, :image_length

  enum item_category: { others: 0, stopper: 1, gate: 2, cushion: 3, key: 4, cover: 5, mat: 6, fence: 7, slope: 8, fall_prevention: 9, storage: 10 }

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
    %w[title body item_info item_category item_merit item_demerit comments.body]
  end

  def self.ransackable_associations(auth_object = nil)
    %w[comments user]
  end
end
