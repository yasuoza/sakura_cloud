# vim:fileencoding=utf-8
require_relative "sakura_cloud/version"
require 'json'
require 'net/https'
require 'uri'
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
  class Server < Hash
    include Request
    attr_accessor :status, :is_ok, :result
    def initialize(server_id,opts={})
      @server_id = server_id
      @result=get("/server/#{@server_id}")
      self.merge!(@result["Server"])
      self["is_ok"]=@result["is_ok"]
      @result["Server"].each do |key,value|
        self.class.class_eval{define_method(key){self[key]}}
      end
    end
    def is_ok
      self["is_ok"]
    end
    def monitor
      @monitor ||= get("/server/#{@server_id}/monitor")
    end

  end
end

if $0 == __FILE__
end
