Rails.application.configure do
  # Settings specified here will take precedence over those in config/application.rb.

  # In the development environment your application's code is reloaded on
  # every request. This slows down response time but is perfect for development
  # since you don't have to restart the web server when you make code changes.
  config.cache_classes = false

  # Do not eager load code on boot.
  config.eager_load = false

  # Show full error reports.
  config.consider_all_requests_local = true

  # Enable/disable caching. By default caching is disabled.
  # Run rails dev:cache to toggle caching.
  if Rails.root.join('tmp', 'caching-dev.txt').exist?
    config.action_controller.perform_caching = true

    config.cache_store = :memory_store
    config.public_file_server.headers = {
      'Cache-Control' => "public, max-age=#{2.days.to_i}"
    }
  else
    config.action_controller.perform_caching = false

    config.cache_store = :null_store
  end

  # Store uploaded files on the local file system (see config/storage.yml for options)
  config.active_storage.service = :local

  # ActionMailer configuration
  config.action_mailer.default_url_options = {
    host: ENV["DEV_WEB_CLIENT_HOST"]
  }
  config.action_mailer.delivery_method = :smtp
  config.action_mailer.perform_deliveries = ENV["DEV_MAILER_PERFORM_DELIV"].to_bool
  config.action_mailer.perform_caching = false
  config.action_mailer.raise_delivery_errors = ENV["DEV_MAILER_RAISE_DELIV_ERR"].to_bool
  config.action_mailer.default :charset => "utf-8"
  config.action_mailer.smtp_settings = {
    address: ENV["DEV_SMTP_ADDRESS"],
    port: ENV["DEV_SMTP_PORT"],
    user_name: ENV["DEV_SMTP_USER"],
    password: ENV["DEV_SMTP_PASS"],
    authentication: ENV["DEV_SMTP_AUTH"].try(:to_sym),
    enable_starttls_auto: ENV["DEV_ENABLE_STARTTLS_AUTO"].to_bool
  }
  config.action_mailer.smtp_settings[:domain] = ENV["DEV_SMTP_DOMAIN"] if ENV["DEV_SMTP_DOMAIN"]
  config.action_mailer.default_options = {
    from: ENV["DEV_SMTP_SENDER"]
  }

  # Print deprecation notices to the Rails logger.
  config.active_support.deprecation = :log

  # Raise an error on page load if there are pending migrations.
  config.active_record.migration_error = :page_load

  # Highlight code that triggered database queries in logs.
  config.active_record.verbose_query_logs = true

  # Debug mode disables concatenation and preprocessing of assets.
  # This option may cause significant delays in view rendering with a large
  # number of complex assets.
  config.assets.debug = true

  # Suppress logger output for asset requests.
  config.assets.quiet = true

  # Raises error for missing translations
  # config.action_view.raise_on_missing_translations = true

  # Use an evented file watcher to asynchronously detect changes in source code,
  # routes, locales, etc. This feature depends on the listen gem.
  config.file_watcher = ActiveSupport::EventedFileUpdateChecker
end
