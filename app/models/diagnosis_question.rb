class DiagnosisQuestion < ApplicationRecord
  validates :diagnosis_content_number, presence: true, uniqueness: true
  validates :body, presence: true, length: { maximum: 65_535 }
end
