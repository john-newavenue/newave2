Newave2::Application.configure do
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

  config.action_mailer.raise_delivery_errors = true
  config.action_mailer.delivery_method = :smtp
  config.action_mailer.smtp_settings = {
    address:              'smtp.gmail.com',
    port:                 587,
    domain:               'example.com',
    user_name:            ENV['NOREPLY_EMAIL_USERNAME'],
    password:             ENV['NOREPLY_EMAIL_PASSWORD'],
    authentication:       'plain',
    enable_starttls_auto: true  }

  config.inquiry_recipients = ENV['INQUIRY_RECIPIENTS_STG']

  # Print deprecation notices to the Rails logger.
  config.active_support.deprecation = :log

  # Raise an error on page load if there are pending migrations
  config.active_record.migration_error = :page_load

  # Debug mode disables concatenation and preprocessing of assets.
  config.assets.debug = true

  # trust 192.168.x.x access from Host machine, if applicable
  BetterErrors::Middleware.allow_ip! ENV['TRUSTED_IP'] if ENV['TRUSTED_IP']

  # for devise
  config.action_mailer.default_url_options = { :host => 'localhost:3000' } 

  # paperclip and fog
  config.paperclip_defaults = {
    :storage => :fog, 
    :fog_credentials => {
      :provider => "Rackspace",
      :rackspace_username => ENV['RACKSPACE_USERNAME'],
      :rackspace_api_key => ENV['RACKSPACE_API_KEY'],
      :persistent => false
    }, 
    :fog_directory => ENV['RACKSPACE_FILES_CONTAINER_STG'],
    :fog_host => ENV['RACKSPACE_FILES_CDN_STG']
  }

  # zoho
  config.zoho_settings = {
    :authtoken => ENV['ZOHO_AUTHTOKEN_STG']
  }

end
