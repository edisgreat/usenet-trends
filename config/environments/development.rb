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

  # Don't care if the mailer can't send.
  config.action_mailer.raise_delivery_errors = false

  config.action_mailer.perform_caching = false

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

  logger           = ActiveSupport::Logger.new(STDOUT)
  #logger           = Logdna::RailsLogger.new(ENV['logdna_api_key'], {level: 'DEBUG'})
  logger.formatter = config.log_formatter
  logger.level = Logger::DEBUG
  config.logger    = ActiveSupport::TaggedLogging.new(logger)
  config.log_level = :debug

  # Use an evented file watcher to asynchronously detect changes in source code,
  # routes, locales, etc. This feature depends on the listen gem.
  config.file_watcher = ActiveSupport::EventedFileUpdateChecker

  # Install the Timber.io logger
  # ----------------------------
  # Remove the `http_device` to stop sending development logs to Timber.
  # Be sure to keep the `file_device` or replace it with `STDOUT`.
  http_device = Timber::LogDevices::HTTP.new('7376_ae8b7c1228003137:cd5554bce21ae387f7d45e0cfac92de4f1b7146a3973720c51f764e8f07f8fc3')
  file_device = File.open("#{Rails.root}/log/development.log", "a")
  file_device.binmode
  log_devices = [http_device, file_device]

  # Do not modify below this line. It's important to keep the `Timber::Logger`
  # because it provides an API for logging structured data and capturing context.
  logger = Timber::Logger.new(*log_devices)
  logger.level = config.log_level
  config.logger = ActiveSupport::TaggedLogging.new(logger)

end
