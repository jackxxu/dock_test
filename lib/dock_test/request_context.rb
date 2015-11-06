require 'simple_oauth'

module DockTest
  class RequestContext

    def initialize(options)
      @options = options
    end

    def http_request
      @_request ||= Net::HTTP.const_get(verb.capitalize).new(uri.request_uri).tap do |req|

                      # add the params to the body of other requests
                      req.body = params if verb_has_side_effects?

                      # sets the headers
                      headers.each do |key, value|
                        req[key] = value
                      end
                    end
    end

    def curl_command
      headers_string = http_request.to_hash.
                            map {|key, vals| vals.map {|val| [key, val]}.flatten}.
                            map {|x| "-H '#{x[0].capitalize}: #{x[1]}'"}.join(' ')
      "curl -vv -X #{http_request.method.upcase} -d '#{http_request.body}' #{headers_string} '#{request_url}'"
    end

    def execute
      Net::HTTP.start(uri.hostname, uri.port,
                      :use_ssl => (uri.scheme == 'https'),
                      :verify_mode => OpenSSL::SSL::VERIFY_NONE) do |http|

        oauth_sign! if DockTest.oauth? # processing oauth signing

        http.request(http_request)
      end

    end

    def verb_has_side_effects?
      %w(post put patch delete).include?(verb)
    end

    private

      def verb()     @options[:verb];    end
      def path()     @options[:path];    end
      def headers()  @options[:headers]; end
      def params()   @options[:params];  end
      def endpoint() DockTest.url;      end

      def oauth_sign!
        http_request['Authorization'] =
          SimpleOAuth::Header.new(verb,
                                  request_url,
                                  {},
                                  :consumer_key => DockTest.oauth_consumer_key,
                                  :consumer_secret => DockTest.oauth_consumer_secret)
      end

      def uri
        @_uri ||= URI.parse(request_url).tap do |uri|

                    uri.port = DockTest.port if DockTest.localhost?

                    # add the params to the GET requests
                    if !verb_has_side_effects? && !params.empty?
                      if(params.is_a?(Hash))
                        uri.query = URI.encode_www_form(URI.decode_www_form(uri.query || '') + params.to_a)
                      else
                        uri.query = uri.query.nil? ? params : "#{uri.query}&#{params}"
                      end
                    end
                  end
      end

      def request_url
        end_path = path().dup
        if end_path.start_with?('http')
          end_path
        else
          url = endpoint.dup
          url = url[0..1] if url.end_with?('/')
          end_path = end_path[1..-1] if end_path.start_with?('/')
          "#{url}#{path}"
        end
      end

  end
end
