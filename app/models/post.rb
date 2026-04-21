class Post < ApplicationRecord
  ALLOWED_IMAGE_TYPES = %w[image/jpeg image/png image/gif image/webp image/heic].freeze
  MAX_IMAGE_SIZE = 10.megabytes

  validates :body, presence: true
  has_one_attached :image

  validate :validate_image, if: -> { image.attached? }

  broadcasts_to ->(post) { "posts" }, inserts_by: :prepend

  private

  def validate_image
    unless image.blob.filename.present?
      errors.add(:image, "filename must be present")
    end

    unless ALLOWED_IMAGE_TYPES.include?(image.blob.content_type)
      errors.add(:image, "must be a JPEG, PNG, GIF, WebP, or HEIC image")
    end

    if image.blob.byte_size > MAX_IMAGE_SIZE
      errors.add(:image, "must be less than 10MB")
    end
  rescue StandardError => e
    errors.add(:image, "could not be processed: #{e.message}")
  end
