require 'simple_oauth'

module DockTest
  module Methods

    %w(get post put patch delete options head).each do |meth_name|
      define_method meth_name do |path, params = '', headers = {}, &block|

        context = RequestContext.new(verb: meth_name, path: path, params: params, headers: headers)

        if DockTest.skippy? && context.verb_has_side_effects
          skip('this test is skipped in order to avoid potential side effects.')
        end

        @last_request = context.http_request
        @last_response = context.execute

        puts context.curl_command if ENV['OUTPUT_CURL']

        yield @last_response if block_given?

        @last_response
      end

    end

    private

      def last_response
        @last_response
      end

      def last_response_json
        MultiJson.load last_response.body
      end

      def last_request
        @last_request
      end

  end
end
