module DockTest
  module DSL

    attr_reader :url
    # sets the test url
    # also creates a new webrick server process
    def url=(value)
      @url = value

      if localhost? && @server_thread.nil?
        require "rack"
        require 'webrick'
        server = WEBrick::HTTPServer.new(:Port => port).tap do |server|
          server.mount '/', Rack::Handler::WEBrick, Rack::Server.new.app
        end
        @server_thread = Thread.new { server.start }
        trap('INT') do
          server.shutdown
          exit
        end
      end
    end

    def port
      URI.parse(@url).port
    end

    def localhost?
      @url && ['127.0.0.1', 'localhost'].include?(URI.parse(@url).host)
    end

    def skippy=(envs)
      @skippy_envs = Array(envs).map(&:to_s)
    end

    def skippy_envs
      @skippy_envs ||= ['production']
    end

    def configure(&block)
      block.call(DockTest)
    end
  end
end
