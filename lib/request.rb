module SakuraCloud
  API_URL_BASE='https://secure.sakura.ad.jp/cloud/api/cloud/1.0'

  module Request
    def get(path,option={})
      api_request(:get,path,option)
    end
    def api_request(method,path,option={})
      api_key = option[:api_key] || ENV['SAKURA_CLOUD_API_KEY'] || raise(ArgumentError)
      api_secret = option[:api_secret] || ENV['SAKURA_CLOUD_API_SECRET'] || raise(ArgumentError)
      api_uri=URI.parse(API_URL_BASE)
      api_server=Net::HTTP.new(api_uri.host,api_uri.port)
      Net::HTTP.version_1_2
      if api_uri.scheme=="https"
        api_server.use_ssl=true 
        api_server.verify_mode = OpenSSL::SSL::VERIFY_NONE
      end
      response=nil
      api_server.start do|http|
        case method
        when :get
          request =Net::HTTP::Get.new(API_URL_BASE+path)
        when :put
          request =Net::HTTP::Put.new(API_URL_BASE+path)
        when :delete
          request =Net::HTTP::Delete.new(API_URL_BASE+path)
        when :post
          request =Net::HTTP::Post.new(API_URL_BASE+path)
        end
        request.basic_auth api_key, api_secret
        request.set_form_data option
        response = http.request(request)
      end
      begin
        JSON.parse(response.body)
      rescue
        response
      end
    end
  end
end

