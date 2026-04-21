class Subscription < ApplicationRecord
  PLANS = {
    "free" => { name: "Free", price: 0 },
    "premium_monthly" => { name: "Premium Monthly", price: 499 }, # $4.99/month
    "premium_yearly" => { name: "Premium Yearly", price: 4999 } # $49.99/year
  }.freeze

  belongs_to :user

  validates :plan, inclusion: { in: PLANS.keys.map(&:to_s) }

  scope :active, -> { where(status: "active") }
  scope :premium, -> { where("plan != ?", "free") }

  def premium?
    plan != "free" && status == "active"
  end

  def features
    case plan
    when "premium_monthly", "premium_yearly"
      {
        no_ads: true,
        high_quality_images: true,
        badge: "premium",
        priority_support: true
      }
    else
      {
        no_ads: false,
        high_quality_images: false,
        badge: nil,
        priority_support: false
      }
    end
  end
end