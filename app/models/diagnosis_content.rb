class DiagnosisContent < ApplicationRecord
  validates :number, presence: true, uniqueness: true
  validates :title, presence: true, length: { maximum: 255 }
  validates :image, length: { maximum: 255 }
  validates :danger, length: { maximum: 65_535 }
  validates :item_name, length: { maximum: 255 }
  validates :item_description, length: { maximum: 65_535 }
  validates :item_point, length: { maximum: 65_535 }
  validates :rakuten_item_image_url, length: { maximum: 65_535 }
  validates :rakuten_item_url, length: { maximum: 65_535 }
end
