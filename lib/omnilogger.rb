class Omnilogger
  def initialize(*types)
    @loggers = {}
    types.each do |type|
      @loggers[type]           = Logger.new("log/#{type.to_s.pluralize}.log", 'monthly')
      @loggers[type].formatter = OmniFormatter.new '%Y-%m-%dT%H:%M:%S'
    end
  end

  def log(type, msg)
    @loggers[type].info msg
  end

  private

  def method_missing(method, *args, &block)
    begin
      @loggers[method].info *args, &block
    rescue => err
      ApplicationController.logger.error err
    end
  end

  class OmniFormatter < ::Logger::Formatter
    TEMPLATE = "[%s] %s\n"

    def initialize(dtf)
      @datetime_format = dtf
    end

    def call(severity, timestamp, progname, msg)
      TEMPLATE % [format_datetime(timestamp), msg]
    end
  end
end