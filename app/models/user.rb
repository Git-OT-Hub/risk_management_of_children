class User < ApplicationRecord
  authenticates_with_sorcery!
  has_many :authentications, dependent: :destroy
  accepts_nested_attributes_for :authentications

  has_many :posts, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :bookmarks, dependent: :destroy
  has_many :bookmark_posts, through: :bookmarks, source: :post
  has_many :favorites, dependent: :destroy
  has_many :favorite_posts, through: :favorites, source: :post

  has_one_attached :avatar

  validates :password, length: { minimum: 8 }, if: -> { new_record? || changes[:crypted_password] }
  validates :password, confirmation: true, if: -> { new_record? || changes[:crypted_password] }
  validates :password_confirmation, presence: true, if: -> { new_record? || changes[:crypted_password] }
  validates :name, presence: true, length: { maximum: 255 }
  validates :email, uniqueness: { message: ": %{value} は登録できません" }, presence: true
  validates :reset_password_token, uniqueness: true, allow_nil: true
  validate :avatar_content_type, :avatar_size

  def avatar_as_small
    avatar.variant(resize_to_limit: [250, 250]).processed.url
  end

  def own?(object)
    object.user_id == id
  end

  def bookmark?(post)
    post.bookmarks.pluck(:user_id).include?(id)
  end

  def bookmark(post)
    bookmark_posts << post
  end

  def unbookmark(post)
    bookmark_posts.destroy(post)
  end

  def favorite?(post)
    post.favorites.pluck(:user_id).include?(id)
  end

  def favorite(post)
    favorite_posts << post
  end

  def remove_favorite(post)
    favorite_posts.destroy(post)
  end

  private

  def avatar_content_type
    if avatar.attached? && !avatar.blob.content_type.in?(%w[image/jpeg image/jpg image/png image/gif])
      errors.add(:avatar, ": ファイル形式が、JPEG, JPG, PNG, GIF 以外になっています。ファイル形式をご確認ください。")
    end
  end

  def avatar_size
    if avatar.attached? && avatar.blob.byte_size > 5.megabytes
      errors.add(:avatar, ": 1枚あたり、5MB以下にしてください。")
    end
  end
end
