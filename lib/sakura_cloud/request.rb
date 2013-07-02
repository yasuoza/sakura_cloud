module SakuraCloud
  API_URL_BASE='https://secure.sakura.ad.jp/cloud/api/cloud/1.0'

  module Request
    %w(get post put delete).each do |m|
      define_method(m) do |path, option={}|
        api_request(m.to_sym, path, option)
      end
    end

    def api_request(method, path, option={})
      api_key = option[:api_key] || API_KEY || raise(ArgumentError)
      api_secret = option[:api_secret] || API_SECRET || raise(ArgumentError)
      api_uri = URI.parse(API_URL_BASE)
      api_server = Net::HTTP.new(api_uri.host, api_uri.port)
      Net::HTTP.version_1_2

      if api_uri.scheme == "https"
        api_server.use_ssl = true
        api_server.verify_mode = OpenSSL::SSL::VERIFY_NONE
      end

      response = nil
      api_endpoint = API_URL_BASE + path
      api_server.start do |http|
        case method
        when :get
          api_endpoint << '?' + params(option) unless option.empty?
          request = Net::HTTP::Get.new(api_endpoint)
        when :put
          request = Net::HTTP::Put.new(api_endpoint)
          request.body = params(option) unless option.empty?
        when :delete
          request = Net::HTTP::Delete.new(api_endpoint)
          request.body = params(option) unless option.empty?
        when :post
          request = Net::HTTP::Post.new(api_endpoint)
          request.body = params(option) unless option.empty?
        end
        request.basic_auth(api_key, api_secret)
        response = http.request(request)
      end

      response.body
    end

    private

    def params(opts={})
      MultiJson.encode(queryfy(opts))
    end

    def queryfy(hash_obj={})
      if hash_obj.respond_to?(:map)
        values =
          hash_obj.map do |k, v|
            if v.is_a?(Array)
              v.map { |_v| queryfy(_v) }
            elsif v.is_a?(Hash)
              queryfy(v)
            else
              v
            end
          end
        Hash[hash_obj.keys.map(&:to_s).zip(values)]
      else
        hash_obj
      end
    end
  end
end

