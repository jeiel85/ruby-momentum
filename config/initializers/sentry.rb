# Sentry initialization for error tracking and performance monitoring
# Set SENTRY_DSN environment variable in production

if ENV["SENTRY_DSN"].present?
  Sentry.init do |config|
    config.dsn = ENV["SENTRY_DSN"]
    config.breadcrumbs_logger = [ :active_support_logger, :http_logger ]

    # Enable performance monitoring in production
    config.traces_sample_rate = ENV.fetch("SENTRY_TRACES_SAMPLE_RATE", 0.1).to_f

    # Attach user context for debugging
    config.before_send = lambda do |event, _hint|
      if defined?(current_user) && current_user.present?
        event.user ||= {}
        event.user[:id] = current_user.id
        event.user[:email] = current_user.email
      end
      event
    end
  end
end
