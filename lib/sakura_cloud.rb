require 'json'
require 'net/https'
require 'uri'
class SakuraCloud
  VERSION = '0.0.1'
  API_URL_BASE='https://secure.sakura.ad.jp/cloud/api/cloud/0.2'

  def initialize(api_key, api_secret)
    @api_key=api_key
    @api_secret=api_secret
    api_uri=URI.parse(API_URL_BASE)
    @api_server=Net::HTTP.new(api_uri.host,api_uri.port)
    Net::HTTP.version_1_2
    if api_uri.scheme=="https"
      @api_server.use_ssl=true 
      @api_server.verify_mode = OpenSSL::SSL::VERIFY_NONE
    end
  end
  class Server
    def initialize(api_key,api_secret,api_server,server_id)
      @api_key=api_key
      @api_secret=api_secret
      @api_server=api_server
      @server_id=server_id
    end
    def profile
      response=get(@api_server,"/server/"+@server_id)
    end
    alias :server :profile
    def plan=(plan_id)
      response=put(@api_server,"/server/#{@server_id}/to/plan/#{plan_id}")
    end
    def status
      response=get(@api_server,"/server/#{@server_id}/monitor")
    end
    def power
      response=get(@api_server,"/server/#{@server_id}/power")
    end
    def turn_on
      response=put(@api_server,"/server/#{@server_id}/power")
    end
    def turn_off
      response=delete(@api_server,"/server/#{@server_id}/power")
    end
    def reset
      response=put(@api_server,"/server/#{@server_id}/reset")
    end
    def keyboard(*keys) #ex keyboard(["ctrl","alt","delete"])
      response=put(@api_server,"/server/#{@server_id}/keyboard","Keys"=>keys)
    end
    def vnc_snapshot
      response=get(@api_server,"/server/#{@server_id}/vnc/snapshot.png")
    end
    private
    def get(server,path,option={})
      response=api_request(:get,server,path,option)
      begin
        JSON.parse(response.body)
      rescue
        response
      end
    end
    def post(server,path,option={})
      response=api_request(:post,server,path,option)
      begin
        JSON.parse(response.body)
      rescue
        response
      end
    end
    def put(server,path,option={})
      response=api_request(:put,server,path,option)
      begin
        JSON.parse(response.body)
      rescue
        response
      end
    end
    def delete(server,path,option={})
      response=api_request(:delete,server,path,option)
      begin
        JSON.parse(response.body)
      rescue
        response
      end
    end
    def api_request(method,server,path,option={})
      response=nil
      server.start do|http|
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
        request.basic_auth @api_key, @api_secret
        request.set_form_data option
        response = http.request(request)
      end
      response
    end
  end
  def server(server_id)
    Server.new(@api_key,@api_secret,@api_server,server_id)
  end
end

