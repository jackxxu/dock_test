require "dock_test/version"
require "dock_test/methods"
require "dock_test/assertions"

module DockTest

  class << self

    attr_writer :port
    def port
      @port ||= 9999
    end

    attr_reader :url
    # sets the test url
    # also creates a new webrick server process
    def url=(value)
      @url = value
      if localhost?
        require "rack"
        require 'webrick'
        server = WEBrick::HTTPServer.new(:Port => port).tap do |server|
          server.mount '/', Rack::Handler::WEBrick, Rack::Server.new.app
        end
        t = Thread.new { server.start }
        trap('INT') do
          server.shutdown
          exit
        end
      end
    end

    def localhost?
      @url && ['127.0.0.1', 'localhost'].include?(URI.parse(@url).host)
    end
  end
end
