require 'logger'
module Handy
  class SimpleFormatter < ::Logger::Formatter
    # This method is invoked when a log event occurs
    # Override it to match exception display from Ruby Formatter.
    def call(severity, timestamp, progname, msg)
      "#{msg2str(msg)}"
    end
  end

end