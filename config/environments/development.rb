Curarium::Application.configure do
  # Settings specified here will take precedence over those in config/application.rb.

  # In the development environment your application's code is reloaded on
  # every request. This slows down response time but is perfect for development
  # since you don't have to restart the web server when you make code changes.
  config.cache_classes = false

  # Do not eager load code on boot.
  config.eager_load = false

  # Show full error reports and disable caching.
  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = false

  # Don't care if the mailer can't send.
  config.action_mailer.raise_delivery_errors = false

  # Print deprecation notices to the Rails logger.
  config.active_support.deprecation = :log

  # Raise an error on page load if there are pending migrations
  config.active_record.migration_error = :page_load

  # Debug mode disables concatenation and preprocessing of assets.
  # This option may cause significant delays in view rendering with a large
  # number of complex assets.
  config.assets.debug = true

  config.action_mailer.default_url_options = { :host => 'curarium.com' }
  Rails.application.routes.default_url_options[:host] = 'curarium.com'

  config.action_mailer.delivery_method = :sendmail
  config.action_mailer.perform_deliveries = true

  config.middleware.insert_before ActionDispatch::Static, 'ThumbnailHeaders'
end

class ThumbnailHeaders
  def self.image_type( local_file_path )
    png = Regexp.new("\x89PNG".force_encoding("binary"))

    case IO.read(local_file_path, 10)
    when /^GIF8/
      'image/gif'
    when /^#{png}/
      'image/png'
    else
      'image/jpeg'
    end
  end

  def initialize(app)
    @app = app
  end

  def call(env)
    status, headers, body = @app.call(env)

    if env[ 'REQUEST_PATH' ] =~ /^\/thumbnails\//
      headers[ 'Content-Type' ] = ThumbnailHeaders.image_type( Rails.public_path.to_s + env[ 'REQUEST_PATH' ] )
    end

    return [status, headers, body]
  end
end
