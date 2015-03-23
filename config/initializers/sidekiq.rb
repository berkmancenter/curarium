Sidekiq.configure_server do |config|
  config.redis = { :namespace => 'curarium' }
end

Sidekiq.configure_client do |config|
  config.redis = { :namespace => 'curarium' }
end

