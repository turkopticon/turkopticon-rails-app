class HushLogger < Rails::Rack::Logger
  def initialize(app, config = {})
    super app
    @config = config

    @config[:subdomain] ||= []
    @config[:path]      ||= []
  end

  def call(env)
    hush_subdomain = @config[:subdomain].any? { |sd| env['HTTP_HOST'].start_with? sd }
    hush_path      = @config[:path].include?(env['REQUEST_PATH'])
    if hush_subdomain || hush_path
      Rails.logger.silence { @app.call env }
    else
      super env
    end
  end
end