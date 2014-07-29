module DockTest
  module Methods

    %w(get post put patch delete options head).each do |meth_name|
      define_method meth_name do |path, params = '', headers = {}, &block|

        with_side_effects = verb_has_side_effects?(meth_name)

        if with_side_effects && DockTest.skippy_envs.include?(dock_env)
          skip_test_to_avoid_side_efforts
        end

        uri = URI.parse(full_url(DockTest.url, path))

        if DockTest.localhost?
          uri.port = DockTest.port
        end

        # add the params to the GET requests
        if !with_side_effects && !params.empty?
          if(params.is_a?(Hash))
            uri.query = URI.encode_www_form(URI.decode_www_form(uri.query || '') + params.to_a)
          else
            uri.query = uri.query.nil? ? params : "#{uri.query}&#{params}"
          end
        end

        @last_request = Net::HTTP.const_get(meth_name.capitalize).new(uri.request_uri)

        # add the params to the body of other requests
        if with_side_effects
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

      def dock_env
        ENV['DOCK_ENV']
      end

      def verb_has_side_effects?(verb)
        %w(post put patch delete).include?(verb)
      end

      def last_response
        @last_response
      end

      def last_request
        @last_request
      end

      def skip_test_to_avoid_side_efforts
        skip('this test is skipped in order to avoid potential side effects.')
      end

      # cleanse and combine url and path to retrieve a valid full url
      def full_url(url, path)
        url = url[0..1] if url.end_with?('/')
        path = path[1..-1] if path.start_with?('/')
        "#{url}/#{path}"
      end
  end
end
