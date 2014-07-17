module DockTest
  module Methods

    %w(get post put patch delete options head).each do |meth_name|
      define_method meth_name do |path, params = '', headers = {}, &block|

        uri = URI.join(DockTest.url, path)

        if DockTest.localhost?
          uri.port = DockTest.port
        end

        # add the params to the GET requests
        if meth_name == 'get' && !params.empty?
          if(params.is_a?(Hash))
            uri.query = URI.encode_www_form(URI.decode_www_form(uri.query || '') + params.to_a)
          else
            uri.query = uri.query.nil? ? params : "#{uri.query}&#{params}"
          end
        end

        @last_request = Net::HTTP.const_get(meth_name.capitalize).new(uri.request_uri)

        # add the params to the body of other requests
        if meth_name != 'get'
          @last_request.body = params
        end

        # sets the headers
        headers.each do |key, value|
          @last_request.add_field(key, value)
        end

        # execute the request
        @last_response = Net::HTTP.start(uri.hostname, uri.port) do |http|
          http.request(@last_request)
        end

        yield @last_response if block_given?

        @last_response
      end

      private meth_name
    end

    private
      def last_response
        @last_response
      end

      def last_request
        @last_request
      end

  end
end
