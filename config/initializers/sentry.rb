# Sentry initialization for error tracking and performance monitoring
# Set SENTRY_DSN environment variable in production

if ENV["SENTRY_DSN"].present?
  Sentry.init do |config|
    config.dsn = ENV["SENTRY_DSN"]
    config.breadcrumbs.logger = Rails.logger
    config.breadcrumbs.syscat = true
    config.breadcrumbs.slow_api_buffer = 10

    # Enable performance monitoring in production
    config.traces_sample_rate = ENV.fetch("SENTRY_TRACES_SAMPLE_RATE", 0.1).to_f

    # Filter sensitive data
    config.filter = lambda do |event, _hint|
      # Do not send health check requests to Sentry
      event.end_point.exclude?("/health")
    end

    # Attach user context for debugging
    config.before_send = lambda do |event, hint|
      if defined?(Current_user) && Current_user.present?
        event.user ||= {}
        event.user[:id] = Current_user.id
        event.user[:email] = Current_user.email
      end
      event
    end
  end
end