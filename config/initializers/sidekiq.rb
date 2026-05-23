# Sidekiq picks up REDIS_URL automatically; we set it explicitly here
# so misconfigurations fail loudly at boot rather than silently at
# first job enqueue. Wokku's Redis addon links REDIS_URL into the
# app's env when you attach it.
redis_url = ENV.fetch("REDIS_URL") do
  Rails.env.production? ? raise("REDIS_URL is not set — attach a Redis addon") : "redis://localhost:6379/0"
end

Sidekiq.configure_server do |config|
  config.redis = { url: redis_url }
end

Sidekiq.configure_client do |config|
  config.redis = { url: redis_url }
end
