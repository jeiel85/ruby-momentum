# frozen_string_literal: true

# Configure Active Storage service based on environment
# Set ACTIVE_STORAGE_SERVICE env var to 'amazon' or 'r2' for cloud storage

Rails.application.configure do
  config.active_storage.service = if ENV["ACTIVE_STORAGE_SERVICE"].present?
    ENV["ACTIVE_STORAGE_SERVICE"].to_sym
  elsif Rails.env.production?
    # Default to local in production unless explicitly configured
    :local
  else
    :local
  end
end

# For R2 CDN URL generation (optional)
# Add custom domain for Cloudflare R2 if configured
if ENV["R2_CDN_URL"].present?
  Rails.application.routes.default_url_options[:host] = ENV["R2_CDN_URL"]
end