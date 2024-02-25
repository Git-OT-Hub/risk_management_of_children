class DiagnosisResult < ApplicationRecord
  serialize :results, type: Array, coder: YAML
  serialize :statuses, type: Array, coder: YAML

  belongs_to :user

  validates :title, length: { maximum: 255 }
  validate :validate_results, :validate_statuses

  private

  def validate_results
    results.each do |result|
      errors.add(:results, ": 65_535文字以内にしてください。") if result.length > 65_535
    end
  end

  def validate_statuses
    statuses.each do |status|
      errors.add(:statuses, ": 65_535文字以内にしてください。") if status.length > 65_535
    end
  end
end
