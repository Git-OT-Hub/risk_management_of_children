class DiagnosisContent < ApplicationRecord
  validates :number, presence: true, uniqueness: true
  validates :title, presence: true, length: { maximum: 255 }
  validates :image, length: { maximum: 255 }
  validates :danger, length: { maximum: 65_535 }
  validates :item_name, length: { maximum: 255 }
  validates :recommend, length: { maximum: 65_535 }
  validates :rakuten_item_image_url, length: { maximum: 65_535 }
  validates :rakuten_item_text_url, length: { maximum: 65_535 }
end
