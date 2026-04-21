class Post < ApplicationRecord
  ALLOWED_IMAGE_TYPES = %w[image/jpeg image/png image/gif image/webp image/heic].freeze
  MAX_IMAGE_SIZE = 10.megabytes

  validates :body, presence: true

  belongs_to :user

  has_one_attached :image

  has_many :likes, dependent: :destroy
  has_many :bookmarks, dependent: :destroy
  has_many :comments, dependent: :destroy

  validate :validate_image, if: -> { image.attached? }

  broadcasts_to ->(post) { "posts" }, inserts_by: :prepend

  def liked_by?(user)
    likes.exists?(user_id: user.id)
  end

  def bookmarked_by?(user)
    bookmarks.exists?(user_id: user.id)
  end

  def like_count
    likes.count
  end

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
end