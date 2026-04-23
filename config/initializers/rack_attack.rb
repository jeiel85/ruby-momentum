# frozen_string_literal: true

# Rate limiting using Rack::Attack
# Docs: https://github.com/rack/rack-attack

class Rack::Attack
  # Define a throttling rule for IP addresses
  # Allow 10 requests per 10 seconds per IP
  throttle("req/ip", limit: 10, period: 10.seconds) do |req|
    req.ip if req.path.start_with?("/posts") && req.post?
  end

  # Brute-force login protection
  # Allow 5 login attempts per 30 seconds per IP
  throttle("login/ip", limit: 5, period: 30.seconds) do |req|
    req.ip if req.path.start_with?("/users/sign_in") ||
               req.path.start_with?("/users/password") ||
               req.path.start_with?("/users/unlock")
  end
end

# Auto-blocking suspicious IPs
Rails.application.config.middleware.use Rack::Attack

# Notify when blocked
Rack::Attack.cache.store = ActiveSupport::Cache::MemoryStore.new

# Optional: Custom view for throttled responses
Rack::Attack.throttled_response = lambda do |env|
  retry_after = (env["rack.attack.match_data"] || {})["retry_after"] || 10
  [ 429, {
    "Content-Type" => "application/json",
    "Retry-After" => retry_after.to_s
  }, { error: "Rate limit exceeded. Please try again later." }.to_json ]
end