ActiveSupport.on_load(:active_storage_blob) do
  validates :byte_size, numericality: { less_than_or_equal_to: 10.megabytes }
  validate :validate_content_type

  private

  def validate_content_type
    allowed_content_types = ["image/jpeg", "image/jpg", "image/png", "image/gif"]

    unless allowed_content_types.include?(content_type)
      errors.add(:content_type, ": must be jpeg, jpg, png, or gif")
    end
  end
end
