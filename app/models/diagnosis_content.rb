class DiagnosisContent < ApplicationRecord
  serialize :dangers, type: Array, coder: YAML
  serialize :item_names, type: Array, coder: YAML
  serialize :item_descriptions, type: Array, coder: YAML
  serialize :item_points, type: Array, coder: YAML
  serialize :rakuten_item_image_urls, type: Array, coder: YAML
  serialize :rakuten_item_urls, type: Array, coder: YAML
  serialize :rakuten_item_names, type: Array, coder: YAML
  serialize :rakuten_item_tags, type: Array, coder: YAML

  validates :number, presence: true, uniqueness: true
  validates :title, presence: true, length: { maximum: 255 }
  validates :image, length: { maximum: 255 }
  validate :validate_dangers, :validate_item_names, :validate_item_descriptions, :validate_item_points, :validate_rakuten_item_image_urls, :validate_rakuten_item_urls, :validate_rakuten_item_names, :validate_rakuten_item_tags

  private

  def validate_dangers
    dangers.each do |danger|
      errors.add(:dangers, ": 65_535文字以内にしてください。") if danger.length > 65_535
    end
  end

  def validate_item_names
    item_names.each do |name|
      errors.add(:item_names, ": 255文字以内にしてください。") if name.length > 255
    end
  end

  def validate_item_descriptions
    item_descriptions.each do |description|
      errors.add(:item_descriptions, ": 65_535文字以内にしてください。") if description.length > 65_535
    end
  end

  def validate_item_points
    item_points.each do |point|
      errors.add(:item_points, ": 65_535文字以内にしてください。") if point.length > 65_535
    end
  end

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

  def validate_rakuten_item_names
    rakuten_item_names.each do |name|
      errors.add(:rakuten_item_names, ": 65_535文字以内にしてください。") if name.length > 65_535
    end
  end

  def validate_rakuten_item_tags
    rakuten_item_tags.each do |tag|
      errors.add(:rakuten_item_tags, ": 65_535文字以内にしてください。") if tag.length > 65_535
    end
  end
end
