module Omnilogger
  @logs = %i(account flag review moderator admin)

  class << self
    def log(type, msg)
      loggers[type].info msg
    end

    private

    def loggers
      @loggers ||= @logs.map { |type| [type] << make_logger(type) }.to_h
    end

    def make_logger(type)
      l           = Logger.new("log/#{type.to_s.pluralize}.log", 'monthly')
      l.formatter = OmniFormatter.new '%Y-%m-%dT%H:%M:%S'
      l
    end
  end

  def self.method_missing(method, *args)
    begin
      self.log method, *args
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