class Report < ApplicationRecord
  enum :status, { pending: 0, reviewed: 1, resolved: 1 }, default: :pending
  enum :reason, {
    spam: 0,
    inappropriate: 1,
    harassment: 2,
    violence: 3,
    misinformation: 4,
    other: 5
  }, prefix: true

  belongs_to :user
  belongs_to :post, optional: true
  belongs_to :comment, optional: true

  validates :reason, presence: true
  validates :user_id, uniqueness: { scope: [ :post_id, :comment_id ], message: "already reported this content" }

  scope :pending_reviews, -> { where(status: :pending).order(created_at: :desc) }
  scope :with_post_reports, -> { where.not(post_id: nil) }
  scope :with_comment_reports, -> { where.not(comment_id: nil) }
end