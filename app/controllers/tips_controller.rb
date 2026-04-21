class TipsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_recipient, only: [ :create ]

  def index
    @tips = current_user.received_tips.succeeded.order(created_at: :desc)
  end

  def create
    amount = params[:amount].to_i

    # Validate amount
    unless Rails.application.config.stripe[:tip_amounts].include?(amount)
      return redirect_back(fallback_location: root_path, alert: "Invalid tip amount")
    end

    # Prevent self-tipping
    if current_user.id == @recipient.id
      return redirect_back(fallback_location: root_path, alert: "Cannot tip yourself")
    end

    # Create Stripe payment intent
    begin
      payment_intent = Stripe::PaymentIntent.create(
        amount: amount,
        currency: "usd",
        metadata: {
          sender_id: current_user.id,
          recipient_id: @recipient.id
        }
      )

      # Create tip record
      tip = current_user.sent_tips.create!(
        recipient: @recipient,
        amount: amount,
        stripe_payment_intent_id: payment_intent.id,
        message: params[:message],
        status: "pending"
      )

      # Return client secret for Stripe.js
      render json: { client_secret: payment_intent.client_secret, tip_id: tip.id }
    rescue Stripe::StripeError => e
      redirect_back(fallback_location: root_path, alert: "Error creating payment: #{e.message}")
    end
  end

  def webhook
    # Handle Stripe webhooks for successful payments
    payload = request.body.read
    sig_header = request.env["HTTP_STRIPE_SIGNATURE"]
    endpoint_secret = ENV["STRIPE_WEBHOOK_SECRET"]

    begin
      event = Stripe::Webhook.construct_event(payload, sig_header, endpoint_secret)
    rescue JSON::ParserError, Stripe::SignatureVerificationError
      return head :bad_request
    end

    case event.type
    when "payment_intent.succeeded"
      handle_payment_success(event.data.object)
    when "payment_intent.payment_failed"
      handle_payment_failure(event.data.object)
    end

    head :ok
  end

  private

  def set_recipient
    @recipient = User.find(params[:user_id])
  end

  def handle_payment_success(payment_intent)
    tip = Tip.find_by(stripe_payment_intent_id: payment_intent.id)
    return unless tip

    tip.update!(status: "succeeded")
  end

  def handle_payment_failure(payment_intent)
    tip = Tip.find_by(stripe_payment_intent_id: payment_intent.id)
    return unless tip

    tip.update!(status: "failed")
  end
end
