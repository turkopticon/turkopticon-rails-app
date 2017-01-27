class ApplicationMailer < ActionMailer::Base
  default from: 'Turkopticon <noreply@turkopticon.info>'

  # pass these explicitly in the controller due to rspec not picking up normal
  # config options (see: https://github.com/rspec/rspec-rails/issues/1275)
  # which doesn't affect production, but neither does this workaround
  default_url_options[:host]     = 'turkopticon.info'
  default_url_options[:protocol] = 'https'

  layout 'mailer'
end
