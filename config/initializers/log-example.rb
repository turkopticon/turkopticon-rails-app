logfile = File.open('/path/to/app_ip.log', 'a')
logfile.sync = true
IPLogger = Logger.new(logfile)
