class DiagnosisContent < ApplicationRecord
  serialize :rakuten_item_image_urls, type: Array, coder: YAML
  serialize :rakuten_item_urls, type: Array, coder: YAML

  validates :number, presence: true, uniqueness: true
  validates :title, presence: true, length: { maximum: 255 }
  validates :image, length: { maximum: 255 }
  validates :danger, length: { maximum: 65_535 }
  validates :item_name, length: { maximum: 255 }
  validates :item_description, length: { maximum: 65_535 }
  validates :item_point, length: { maximum: 65_535 }
  validate :validate_rakuten_item_image_urls, :validate_rakuten_item_urls

  private

  def validate_rakuten_item_image_urls
    rakuten_item_image_urls.each do |url|
      errors.add(:rakuten_item_image_urls, ": 65_535文字以内にしてください。") if url.length > 65_535
    end
  end

  def validate_rakuten_item_urls
    rakuten_item_urls.each do |url|
      errors.add(:rakuten_item_urls, ": 65_535文字以内にしてください。") if url.length > 65_535
    end
  end
end

rakuten_item_names