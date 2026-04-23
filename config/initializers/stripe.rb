# Stripe configuration for payments
# Set STRIPE_SECRET_KEY and STRIPE_PUBLISHABLE_KEY environment variables

if ENV["STRIPE_SECRET_KEY"].present?
  Stripe.api_key = ENV["STRIPE_SECRET_KEY"]

  # Stripe webhook signing secret (optional but recommended for production)
  # Set STRIPE_WEBHOOK_SECRET environment variable
  Stripe.signing_secret = ENV["STRIPE_WEBHOOK_SECRET"] if ENV["STRIPE_WEBHOOK_SECRET"].present?
end

Rails.application.configure do
  config.stripe = {
    publishable_key: ENV["STRIPE_PUBLISHABLE_KEY"],
    # Prices for premium subscriptions (in smallest currency unit, e.g., cents)
    premium_monthly_price_id: ENV["STRIPE_PREMIUM_MONTHLY_PRICE_ID"],
    premium_yearly_price_id: ENV["STRIPE_PREMIUM_YEARLY_PRICE_ID"],
    # Tips configuration (in cents)
    tip_amounts: [ 500, 1000, 2000, 5000 ] # $5, $10, $20, $50
  }
end