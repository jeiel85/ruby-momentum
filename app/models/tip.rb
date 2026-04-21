class Tip < ApplicationRecord
  belongs_to :sender, class_name: "User"
  belongs_to :recipient, class_name: "User"

  validates :amount, presence: true, numericality: { greater_than: 0 }
  validates :message, length: { maximum: 500 }

  scope :succeeded, -> { where(status: "succeeded") }
  scope :for_user, ->(user_id) { where(recipient_id: user_id) }

  def USD
    amount.to_f / 100
  end

  def status_label
    case status
    when "succeeded" then "✓"
    when "pending" then "⏳"
    when "failed" then "✗"
    when "refunded" then "↩"
    else status
    end
  end
end