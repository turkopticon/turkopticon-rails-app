# Be sure to restart your server when you modify this file

# Specifies gem version of Rails to use when vendor/rails is not present
RAILS_GEM_VERSION = '2.3.11' unless defined? RAILS_GEM_VERSION

# Bootstrap the Rails environment, frameworks, and default configuration
require File.join(File.dirname(__FILE__), 'boot')

Rails::Initializer.run do |config|
  config.time_zone = "Pacific Time (US & Canada)"
  # config.time_zone = 'UTC'
  config.gem "haml"
  config.gem 'mislav-will_paginate', :lib => 'will_paginate'
  # config.action_mailer.delivery_method = :sendmail
  config.action_mailer.delivery_method = :smtp  # smtp settings in
                                                # config/initializers/smtp_gmail.rb
  config.action_controller.session_store = :cookie_store
  config.action_controller.session = {
    :key => '_turkopticon_session',
    :secret => 'secret'
  }
end
ActionController::Base.session_options[:expire_after] = 1.year
require 'acts_as_ferret'
