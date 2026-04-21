class SubscriptionsController < ApplicationController
  before_action :authenticate_user!

  def show
    @subscription = current_user.subscription || current_user.build_subscription
  end

  def create
    # Create Stripe checkout session for subscription
    # This is a placeholder - actual implementation requires Stripe JS SDK on frontend
    plan = params[:plan] || "premium_monthly"

    unless Subscription::PLANS.key?(plan)
      return redirect_to subscription_path, alert: "Invalid plan selected"
    end

    # Create or get Stripe customer
    customer = current_user.subscription&.stripe_customer_id ||
              Stripe::Customer.create(email: current_user.email).id

    # Create checkout session
    session = Stripe::Checkout::Session.create(
      customer: customer,
      mode: "subscription",
      line_items: [{
        price: Rails.application.config.stripe[:"#{plan}_price_id"],
        quantity: 1
      }],
      success_url: subscription_url + "?status=success",
      cancel_url: subscription_url + "?status=cancelled"
    )

    redirect_to session.url, allow_external_redirect: true
  end

  def cancel
    subscription = current_user.subscription
    return redirect_to subscription_path, alert: "No active subscription" unless subscription

    begin
      Stripe::Subscription.cancel(subscription.stripe_subscription_id)
      subscription.update!(status: "canceled")
      redirect_to subscription_path, notice: "Subscription cancelled"
    rescue Stripe::StripeError => e
      redirect_to subscription_path, alert: "Error cancelling subscription: #{e.message}"
    end
  end

  def webhook
    # Handle Stripe webhooks
    payload = request.body.read
    sig_header = request.env["HTTP_STRIPE_SIGNATURE"]
    endpoint_secret = ENV["STRIPE_WEBHOOK_SECRET"]

    begin
      event = Stripe::Webhook.construct_event(payload, sig_header, endpoint_secret)
    rescue JSON::ParserError, Stripe::SignatureVerificationError
      return head :bad_request
    end

    case event.type
    when "customer.subscription.created", "customer.subscription.updated"
      handle_subscription_event(event.data.object)
    when "customer.subscription.deleted"
      handle_subscription_deleted(event.data.object)
    end

    head :ok
  end

  private

  def handle_subscription_event(stripe_subscription)
    user = User.find_by(email: stripe_subscription.customer.email)
    return unless user

    subscription = user.subscription || user.build_subscription
    subscription.update!(
      stripe_customer_id: stripe_subscription.customer,
      stripe_subscription_id: stripe_subscription.id,
      plan: extract_plan(stripe_subscription),
      status: stripe_subscription.status,
      current_period_start: Time.at(stripe_subscription.current_period_start),
      current_period_end: Time.at(stripe_subscription.current_period_end)
    )
  end

  def handle_subscription_deleted(stripe_subscription)
    user = User.find_by(email: stripe_subscription.customer.email)
    return unless user

    subscription = user.subscription
    subscription&.update!(status: "canceled", plan: "free")
  end

  def extract_plan(stripe_subscription)
    price_id = stripe_subscription.items.data.first.price.id
    case price_id
    when Rails.application.config.stripe[:premium_monthly_price_id]
      "premium_monthly"
    when Rails.application.config.stripe[:premium_yearly_price_id]
      "premium_yearly"
    else
      "free"
    end
  end
end