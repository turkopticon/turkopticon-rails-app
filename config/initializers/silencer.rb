require 'hush-logger'

Rails.application.configure do
  config.middleware.swap Rails::Rack::Logger, HushLogger, subdomain: ['api']
end