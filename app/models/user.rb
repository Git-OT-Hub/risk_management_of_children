class User < ApplicationRecord
  authenticates_with_sorcery!
  has_many :authentications, dependent: :destroy
  accepts_nested_attributes_for :authentications

  has_many :posts, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :comment_replies, dependent: :destroy
  has_many :bookmarks, dependent: :destroy
  has_many :bookmark_posts, through: :bookmarks, source: :post
  has_many :favorites, dependent: :destroy
  has_many :favorite_posts, through: :favorites, source: :post
  has_many :diagnosis_results, dependent: :destroy
  has_many :sent_notifications, class_name: 'Notification', foreign_key: 'sender_id', dependent: :destroy
  has_many :received_notifications, class_name: 'Notification', foreign_key: 'recipient_id', dependent: :destroy
  has_many :notifications, as: :notifiable, dependent: :destroy

  has_one_attached :avatar do |attachable|
    attachable.variant :small, resize_to_limit: [250, 250], preprocessed: true
  end

  validates :password, length: { minimum: 8 }, if: -> { new_record? || changes[:crypted_password] }
  validates :password, confirmation: true, if: -> { new_record? || changes[:crypted_password] }
  validates :password_confirmation, presence: true, if: -> { new_record? || changes[:crypted_password] }
  validates :name, presence: true, length: { maximum: 30 }
  validates :email, uniqueness: { message: ": %{value} は登録できません" }, presence: true
  validates :reset_password_token, uniqueness: true, allow_nil: true
  validate :avatar_content_type, :avatar_size

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

  def notified_reply_objects(comment)
    objects = self.received_notifications.unread_comment_replies.order(created_at: :desc)
    results = []
    objects.each do |object|
      if object.notifiable.comment.id == comment.id
        results << object
      end
    end
    results
  end

  def notified_comment_objects(post)
    objects = self.received_notifications.unread_comments.order(created_at: :desc)
    results = []
    objects.each do |object|
      if object.notifiable.post.id == post.id
        results << object
      end
    end
    results
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

  def self.ransackable_attributes(auth_object = nil)
    %w[name]
  end

  def self.ransackable_associations(auth_object = nil)
    %w[posts comments comment_replies]
  end
end
